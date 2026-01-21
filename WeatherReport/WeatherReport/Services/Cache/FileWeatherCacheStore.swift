//
//  FileWeatherCacheStore.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

actor FileWeatherCacheStore: WeatherCacheStoring {
    private let fileManager: FileManager
    private let directoryURL: URL
    private let coding: any JSONCoding

    init(
        fileManager: FileManager = .default,
        directoryName: String = "weather-cache",
        coding: any JSONCoding
    ) throws {
        self.fileManager = fileManager
        self.coding = coding

        let caches = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )

        self.directoryURL = caches.appendingPathComponent(directoryName, isDirectory: true)
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    func loadEntry(for airport: String) async throws -> CachedWeatherEntry? {
        let url = fileURL(for: airport)

        guard fileManager.fileExists(atPath: url.path) else { return nil }

        let data = try await Task.detached(priority: .utility) {
            try Data(contentsOf: url)
        }.value

        return try coding.makeDecoder().decode(CachedWeatherEntry.self, from: data)
    }

    func saveEntry(_ entry: CachedWeatherEntry, for airport: String) async throws {
        let url = fileURL(for: airport)

        let data = try coding.makeEncoder().encode(entry)

        try await Task.detached(priority: .utility) {
            try data.write(to: url, options: [.atomic])
        }.value
    }
    
    func deleteEntry(for airport: String) async throws {
        let url = fileURL(for: airport)
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    private func fileURL(for airport: String) -> URL {
        let key = AirportKey.normalize(airport)
        return directoryURL.appendingPathComponent("\(key).json")
    }
}
