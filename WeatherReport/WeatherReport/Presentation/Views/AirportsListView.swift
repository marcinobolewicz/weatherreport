//
//  AirportsListView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

struct AirportsListView: View {
    
    @Environment(AppRouter.self) private var router
    
    let storage: AirportsStorage
    @State private var newAirportText = ""
    
    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            List {
                airportsSection
                addAirportSection
            }
            .navigationTitle("Airports")
            .navigationDestination(for: Route.self) { route in
                destinationView(for: route)
            }
        }
    }
}

// MARK: - View Components

private extension AirportsListView {
    
    var airportsSection: some View {
        Section {
            ForEach(storage.airports, id: \.self) { identifier in
                AirportRowView(identifier: identifier) {
                    router.navigate(to: .airportDetails(identifier: identifier))
                }
            }
            .onDelete { offsets in
                storage.remove(at: offsets)
            }
        }
    }
    
    var addAirportSection: some View {
        Section {
            HStack {
                TextField("Airport code (e.g. KJFK)", text: $newAirportText)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .onSubmit(addAirport)
                
                Button("Add", action: addAirport)
                    .disabled(newAirportText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
    
    @ViewBuilder
    func destinationView(for route: Route) -> some View {
        switch route {
        case .airportDetails(let identifier):
            WeatherDetailsView(airportIdentifier: identifier)
        }
    }
}

// MARK: - Actions

private extension AirportsListView {
    
    func addAirport() {
        let identifier = newAirportText
            .trimmingCharacters(in: .whitespaces)
            .uppercased()
        
        guard !identifier.isEmpty else { return }
        
        // Add to storage (handles duplicates internally)
        storage.add(identifier)
        newAirportText = ""
        
        // Navigate to details
        router.navigate(to: .airportDetails(identifier: identifier))
    }
}

// MARK: - Airport Row View

private struct AirportRowView: View {
    
    let identifier: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(identifier)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    AirportsListView(storage: AirportsStorage())
        .environment(AppRouter())
}
