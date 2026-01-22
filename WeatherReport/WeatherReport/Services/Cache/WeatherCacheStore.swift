//
//  WeatherCacheStore.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

struct CachedWeatherEntry: Codable, Sendable {
    let retrievedAt: Date
    let payload: Data
}

protocol WeatherCacheStoring: Sendable {
    func loadEntry(for airport: String) async throws -> CachedWeatherEntry?
    func saveEntry(_ entry: CachedWeatherEntry, for airport: String) async throws
    func deleteEntry(for airport: String) async throws
    func deleteAll() async throws 
}
