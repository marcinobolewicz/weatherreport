//
//  WeatherCacheStoreTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 21/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("WeatherCacheStore Tests")
struct WeatherCacheStoreTests {
    
    // MARK: - InMemoryWeatherCacheStore
    
    @Test("InMemoryWeatherCacheStore saves, loads and deletes")
    func inMemorySavesLoadsDeletes() async throws {
        let sut = InMemoryWeatherCacheStore()
        let key = "  kpwm  "
        let entry = CachedWeatherEntry(retrievedAt: Date(), payload: Data("test".utf8))
        
        try await sut.saveEntry(entry, for: key)
        let loaded = try await sut.loadEntry(for: "KPWM")
        #expect(loaded?.payload == entry.payload)
        
        try await sut.deleteEntry(for: "kpwm")
        let deleted = try await sut.loadEntry(for: "KPWM")
        #expect(deleted == nil)
    }
    
    // MARK: - FileWeatherCacheStore
    
    @Test("FileWeatherCacheStore saves, loads and deletes")
    func fileStoreSavesLoadsDeletes() async throws {
        let directoryName = "weather-cache-test-\(UUID().uuidString)"
        let fileManager = FileManager.default
        let sut = try FileWeatherCacheStore(
            fileManager: fileManager,
            directoryName: directoryName,
            coding: DefaultJSONCoding()
        )
        
        let entry = CachedWeatherEntry(
            retrievedAt: Date(timeIntervalSince1970: 1_700_000_000),
            payload: Data("payload".utf8)
        )
        
        try await sut.saveEntry(entry, for: " kpwm ")
        let loaded = try await sut.loadEntry(for: "KPWM")
        #expect(loaded?.payload == entry.payload)
        #expect(loaded?.retrievedAt == entry.retrievedAt)
        
        try await sut.deleteEntry(for: "KPWM")
        let deleted = try await sut.loadEntry(for: "kpwm")
        #expect(deleted == nil)
        
        // Cleanup
        let caches = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let dir = caches.appendingPathComponent(directoryName, isDirectory: true)
        try? fileManager.removeItem(at: dir)
    }
}
