//
//  WeatherRepository.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

enum ReportEvent: Sendable {
    case cache(WeatherReportDTO, retrievedAt: Date)
    case live(WeatherReportDTO, retrievedAt: Date)
    case refreshFailedUsingCache(Error)
}

protocol WeatherRepository: Sendable {
    func observeOnAppear(airport: String) -> AsyncThrowingStream<ReportEvent, Error>
    func refresh(airport: String) async throws -> ReportResult
    func clearCache() async throws
}

final class DefaultWeatherRepository: WeatherRepository, Sendable {
    private let live: any WeatherService
    private let cache: any WeatherCacheStoring
    private let coding: any JSONCoding
    private let now: @Sendable () -> Date
    private let log: @Sendable (String) -> Void

    init(
        live: any WeatherService,
        cache: any WeatherCacheStoring,
        coding: any JSONCoding,
        now: @escaping @Sendable () -> Date = Date.init,
        log: @escaping @Sendable (String) -> Void = { _ in }
    ) {
        self.live = live
        self.cache = cache
        self.coding = coding
        self.now = now
        self.log = log
    }

    func observeOnAppear(airport: String) -> AsyncThrowingStream<ReportEvent, Error> {
        let key = AirportKey.normalize(airport)

        return AsyncThrowingStream { continuation in
            let task = Task(priority: .userInitiated) { [weak self] in
                guard let self else { return }
                await self.runObserveFlow(key: key, continuation: continuation)
            }
            continuation.onTermination = { @Sendable _ in task.cancel() }
        }
    }

    func refresh(airport: String) async throws -> ReportResult {
        let key = AirportKey.normalize(airport)
        let dto = try await live.fetchReport(for: key)
        await safeSave(dto: dto, key: key)
        return .init(dto: dto, source: .live)
    }
    
    func clearCache() async throws {
        try await cache.deleteAll()
    }
}

// MARK: - Observe flow

private extension DefaultWeatherRepository {
    func runObserveFlow(
        key: String,
        continuation: AsyncThrowingStream<ReportEvent, Error>.Continuation
    ) async {
        let hadCache = await yieldCacheIfPresent(key: key, continuation: continuation)

        do {
            let (dto, retrievedAt) = try await fetchLiveAndCache(key: key)
            continuation.yield(.live(dto, retrievedAt: retrievedAt))
            continuation.finish()
        } catch {
            finishAfterLiveFailure(
                error: error,
                hadCache: hadCache,
                continuation: continuation
            )
        }
    }

    func yieldCacheIfPresent(
        key: String,
        continuation: AsyncThrowingStream<ReportEvent, Error>.Continuation
    ) async -> Bool {
        do {
            guard let entry = try await cache.loadEntry(for: key) else { return false }
            do {
                let dto = try decode(entry.payload)
                continuation.yield(.cache(dto, retrievedAt: entry.retrievedAt))
                return true
            } catch {
                log("Cache decode failed for \(key): \(error)")
                try? await cache.deleteEntry(for: key) 
                return false
            }
        } catch {
            log("Cache load failed for \(key): \(error)")
            return false
        }
    }

    func fetchLiveAndCache(key: String) async throws -> (WeatherReportDTO, Date) {
        let dto = try await live.fetchReport(for: key)
        let retrievedAt = now()
        await safeSave(dto: dto, key: key)
        return (dto, retrievedAt)
    }

    func finishAfterLiveFailure(
        error: Error,
        hadCache: Bool,
        continuation: AsyncThrowingStream<ReportEvent, Error>.Continuation
    ) {
        if hadCache {
            continuation.yield(.refreshFailedUsingCache(error))
            continuation.finish()
        } else {
            continuation.finish(throwing: error)
        }
    }

    func decode(_ data: Data) throws -> WeatherReportDTO {
        try coding.makeDecoder().decode(WeatherReportDTO.self, from: data)
    }

    func safeSave(dto: WeatherReportDTO, key: String) async {
        do {
            try await saveToCache(dto: dto, key: key)
        } catch {
            log("Cache save failed for \(key): \(error)")
        }
    }

    func saveToCache(dto: WeatherReportDTO, key: String) async throws {
        let payload = try coding.makeEncoder().encode(dto)
        try await cache.saveEntry(.init(retrievedAt: now(), payload: payload), for: key)
    }
}
