//
//  AirportsListView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

struct AirportsListView: View {
    @Environment(AppRouter.self) private var router
    @Bindable var viewModel: AirportsListViewModel

    private var trimmedInput: String {
        viewModel.newAirportText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        List {
            Section {
                ForEach(viewModel.airports, id: \.self) { identifier in
                    Button {
                        router.navigate(to: .airportDetails(identifier))
                    } label: {
                        AirportRowView(identifier: identifier)
                    }
                }
                .onDelete(perform: viewModel.removeAirports)
            }

            Section {
                HStack {
                    TextField("Airport code (e.g. KJFK)", text: $viewModel.newAirportText)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .onSubmit(addAirport)

                    Button("Add", action: addAirport)
                        .disabled(!viewModel.canAddAirport)
                }
            }
        }
    }

    private func addAirport() {
        viewModel.addAirport { id in
            router.navigate(to: .airportDetails(id))
        }
    }
}



// MARK: - Airport Row View

private struct AirportRowView: View {
    let identifier: String
    
    var body: some View {
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

// MARK: - Preview

#Preview {
    let storage = AirportsStorage()
    let viewModel = AirportsListViewModel(storage: storage)
    AirportsListView(viewModel: viewModel)
        .environment(AppRouter())
}
