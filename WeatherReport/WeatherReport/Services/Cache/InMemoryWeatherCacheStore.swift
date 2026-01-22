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
        storage[AirportKey.normalize(airport)]
    }

    func saveEntry(_ entry: CachedWeatherEntry, for airport: String) async throws {
        storage[AirportKey.normalize(airport)] = entry
    }
    
    func deleteEntry(for airport: String) async throws {
        storage[AirportKey.normalize(airport)] = nil
    }
    
    func deleteAll() async throws {
        storage.removeAll()
    }
}
