//
//  InMemoryWeatherCacheStore.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

actor InMemoryWeatherCacheStore: WeatherCacheStoring {
    private var storage: [String: CachedWeatherEntry] = [:]

    func loadEntry(for airport: String) async throws -> CachedWeatherEntry? {
        storage[normalize(airport)]
    }

    func saveEntry(_ entry: CachedWeatherEntry, for airport: String) async throws {
        storage[normalize(airport)] = entry
    }
    
    func deleteEntry(for airport: String) async throws {
        storage[normalize(airport)] = nil
    }
    
    private func normalize(_ airport: String) -> String {
        AirportKey.normalize(airport)
    }
}
