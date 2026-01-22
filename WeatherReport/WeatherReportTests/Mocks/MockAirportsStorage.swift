//
//  MockAirportsStorage.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation
import SwiftUI
@testable import WeatherReport

@MainActor
final class MockAirportsStorage: AirportsStoring {
    private(set) var airports: [String] = []
    private(set) var addedAirports: [String] = []
    private(set) var removedOffsets: [IndexSet] = []
    
    init(airports: [String] = []) {
        self.airports = airports
    }
    
    @discardableResult
    func add(_ identifier: String) -> Bool {
        let normalized = AirportKey.normalize(identifier)
        guard !normalized.isEmpty, !airports.contains(normalized) else { return false }
        airports.append(normalized)
        addedAirports.append(normalized)
        return true
    }
    
    func remove(at offsets: IndexSet) {
        airports.remove(atOffsets: offsets)
        removedOffsets.append(offsets)
    }
    
    func contains(_ identifier: String) -> Bool {
        let normalized = AirportKey.normalize(identifier)
        return airports.contains(normalized)
    }
}
