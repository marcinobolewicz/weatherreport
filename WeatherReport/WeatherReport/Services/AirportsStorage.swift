//
//  AirportsStorage.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

@MainActor
protocol AirportsStorageProtocol {
    var airports: [String] { get }
    @discardableResult func add(_ identifier: String) -> Bool
    func remove(at offsets: IndexSet)
    func contains(_ identifier: String) -> Bool
}

@Observable
@MainActor
final class AirportsStorage: AirportsStorageProtocol {
    
    private enum Constants {
        static let storageKey = "saved_airports"
        static let defaultAirports = ["KPWM", "KAUS"]
    }
    
    private let defaults: UserDefaults
    
    private(set) var airports: [String] = []
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        self.airports = loadAirports()
    }
    
    // MARK: - Public Methods

    @discardableResult
    func add(_ identifier: String) -> Bool {
        let normalized = normalize(identifier)
        guard !normalized.isEmpty, !airports.contains(normalized) else { return false }
        airports.append(normalized)
        save()
        return true
    }
    
    func remove(at offsets: IndexSet) {
        airports.remove(atOffsets: offsets)
        save()
    }
    
    func contains(_ identifier: String) -> Bool {
        airports.contains(normalize(identifier))
    }
    
    // MARK: - Private Methods
    
    private func loadAirports() -> [String] {
        guard let saved = defaults.stringArray(forKey: Constants.storageKey) else {
            let defaultList = Constants.defaultAirports
            defaults.set(defaultList, forKey: Constants.storageKey)
            return defaultList
        }
        return saved
    }
    
    private func save() {
        defaults.set(airports, forKey: Constants.storageKey)
    }
    
    private func normalize(_ identifier: String) -> String {
        identifier
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }
}
