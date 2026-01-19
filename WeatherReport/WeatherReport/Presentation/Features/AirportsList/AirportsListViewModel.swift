//
//  AirportsListViewModel.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

@Observable
@MainActor
final class AirportsListViewModel {
    private let storage: AirportsStorageProtocol
    var newAirportText: String = ""

    var airports: [String] {
        storage.airports
    }

    init(storage: AirportsStorageProtocol) {
        self.storage = storage
    }

    var normalizedAirportCode: String {
        newAirportText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
    }

    var canAddAirport: Bool {
        normalizedAirportCode.count == 4
    }
    
    func addAirport(navigateTo: (String) -> Void) {
        let identifier = newAirportText
            .trimmingCharacters(in: .whitespaces)
            .uppercased()
        
        guard !identifier.isEmpty else { return }
        
        storage.add(identifier)
        newAirportText = ""
        navigateTo(identifier)
    }
    
    func removeAirports(at offsets: IndexSet) {
        storage.remove(at: offsets)
    }
}
