//
//  WeatherRepositoryTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 21/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("WeatherRepository Tests")
struct WeatherRepositoryTests {
    
    enum TestError: Error, Equatable {
        case sample
    }
    
    // MARK: - Helpers
    
    private struct TestWeatherService: WeatherService {
        let result: Result<WeatherReportDTO, Error>
        
        func fetchReport(for airportIdentifier: String) async throws -> WeatherReportDTO {
            try result.get()
        }
    }
    
    private actor CacheSpy: WeatherCacheStoring {
        private var storage: [String: CachedWeatherEntry] = [:]
        private(set) var saveCalls: [String] = []
        private(set) var deleteCalls: [String] = []
        
        var loadError: Error?
        var saveError: Error?
        var deleteError: Error?
        
        func setEntry(_ entry: CachedWeatherEntry, for key: String) {
            storage[key] = entry
        }
        
        func loadEntry(for airport: String) async throws -> CachedWeatherEntry? {
            if let error = loadError { throw error }
            return storage[airport]
        }
        
        func saveEntry(_ entry: CachedWeatherEntry, for airport: String) async throws {
            if let error = saveError { throw error }
            storage[airport] = entry
            saveCalls.append(airport)
        }
        
        func deleteEntry(for airport: String) async throws {
            if let error = deleteError { throw error }
            storage[airport] = nil
            deleteCalls.append(airport)
        }
    }
    
    private func makeRepository(
        live: WeatherService,
        cache: CacheSpy,
        coding: JSONCoding = DefaultJSONCoding()
    ) -> DefaultWeatherRepository {
        DefaultWeatherRepository(
            live: live,
            cache: cache,
            coding: coding,
            now: { Date(timeIntervalSince1970: 1_736_000_000) }
        )
    }
    
    private func collectEvents(
        from stream: AsyncThrowingStream<ReportEvent, Error>
    ) async throws -> [ReportEvent] {
        var events: [ReportEvent] = []
        for try await event in stream {
            events.append(event)
        }
        return events
    }
    
    // MARK: - Tests
    
    @Test("observeOnAppear yields cache then live when cache exists and live succeeds")
    func observeOnAppearYieldsCacheThenLive() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let coding = DefaultJSONCoding()
        let payload = try coding.makeEncoder().encode(dto)
        
        let cache = CacheSpy()
        let key = AirportKey.normalize("KPWM")
        await cache.setEntry(.init(retrievedAt: Date(timeIntervalSince1970: 1_700_000_000), payload: payload), for: key)
        
        let live = TestWeatherService(result: .success(dto))
        let sut = makeRepository(live: live, cache: cache, coding: coding)
        
        let events = try await collectEvents(from: sut.observeOnAppear(airport: "KPWM"))
        
        #expect(events.count == 2)
        
        if case .cache(let cachedDTO, _) = events[0] {
            #expect(cachedDTO == dto)
        } else {
            #expect(Bool(false))
        }
        
        if case .live(let liveDTO, _) = events[1] {
            #expect(liveDTO == dto)
        } else {
            #expect(Bool(false))
        }
    }
    
    @Test("observeOnAppear yields live only when cache is empty")
    func observeOnAppearYieldsLiveOnly() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let cache = CacheSpy()
        let live = TestWeatherService(result: .success(dto))
        let sut = makeRepository(live: live, cache: cache)
        
        let events = try await collectEvents(from: sut.observeOnAppear(airport: "KPWM"))
        
        #expect(events.count == 1)
        if case .live(let liveDTO, _) = events[0] {
            #expect(liveDTO == dto)
        } else {
            #expect(Bool(false))
        }
    }
    
    @Test("observeOnAppear yields cache then refreshFailedUsingCache on live failure")
    func observeOnAppearYieldsRefreshFailedUsingCache() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let coding = DefaultJSONCoding()
        let payload = try coding.makeEncoder().encode(dto)
        
        let cache = CacheSpy()
        let key = AirportKey.normalize("KPWM")
        await cache.setEntry(.init(retrievedAt: Date(), payload: payload), for: key)
        
        let live = TestWeatherService(result: .failure(TestError.sample))
        let sut = makeRepository(live: live, cache: cache, coding: coding)
        
        let events = try await collectEvents(from: sut.observeOnAppear(airport: "KPWM"))
        
        #expect(events.count == 2)
        if case .cache(let cachedDTO, _) = events[0] {
            #expect(cachedDTO == dto)
        } else {
            #expect(Bool(false))
        }
        
        if case .refreshFailedUsingCache = events[1] {
            #expect(Bool(true))
        } else {
            #expect(Bool(false))
        }
    }
    
    @Test("observeOnAppear throws when live fails and cache is empty")
    func observeOnAppearThrowsWhenNoCache() async {
        let cache = CacheSpy()
        let live = TestWeatherService(result: .failure(TestError.sample))
        let sut = makeRepository(live: live, cache: cache)
        
        await #expect(throws: TestError.self) {
            for try await _ in sut.observeOnAppear(airport: "KPWM") { }
        }
    }
    
    @Test("refresh saves to cache on success")
    func refreshSavesToCacheOnSuccess() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let cache = CacheSpy()
        let live = TestWeatherService(result: .success(dto))
        let sut = makeRepository(live: live, cache: cache)
        
        _ = try await sut.refresh(airport: "KPWM")
        
        let calls = await cache.saveCalls
        #expect(calls.count == 1)
        #expect(calls[0] == AirportKey.normalize("KPWM"))
    }
}
