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
    private let storage: AirportsStoring

    var newAirportText: String = ""
    private(set) var airports: [String] = []

    init(storage: AirportsStoring) {
        self.storage = storage
        reloadAirports()
    }

    var normalizedAirportCode: String {
        AirportKey.normalize(newAirportText)
    }

    var canAddAirport: Bool {
        normalizedAirportCode.count == 4
    }

    func addAirport(navigateTo: (String) -> Void) {
        let identifier = AirportKey.normalize(newAirportText)
        guard !identifier.isEmpty else { return }

        storage.add(identifier)
        newAirportText = ""
        reloadAirports()

        navigateTo(identifier)
    }

    func removeAirports(at offsets: IndexSet) {
        storage.remove(at: offsets)
        reloadAirports()
    }

    private func reloadAirports() {
        var seen = Set<String>()
        airports = storage.airports.filter { seen.insert($0).inserted }
    }
}
