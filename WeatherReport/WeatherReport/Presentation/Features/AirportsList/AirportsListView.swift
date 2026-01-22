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

    var body: some View {
        List {
            airportsSection
            addAirportSection
        }
        .toolbar { settingsToolbarItem }
    }
}

private extension AirportsListView {
    var airportsSection: some View {
        Section {
            ForEach(viewModel.airports, id: \.self) { id in
                airportRow(id)
            }
            .onDelete(perform: viewModel.removeAirports)
        }
    }

    var addAirportSection: some View {
        Section {
            HStack(spacing: 12) {
                airportTextField
                addButton
            }
        }
    }
}

// MARK: - Row

private extension AirportsListView {
    func airportRow(_ id: String) -> some View {
        Button {
            router.navigate(to: .airportDetails(id))
        } label: {
            AirportRowView(identifier: id)
        }
    }
}

private extension AirportsListView {
    var airportTextField: some View {
        TextField("Airport code (e.g. KJFK)", text: $viewModel.newAirportText)
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
            .submitLabel(.done)
            .onSubmit(addAirport)
    }

    var addButton: some View {
        Button("Add", action: addAirport)
            .disabled(!viewModel.canAddAirport)
    }

    func addAirport() {
        viewModel.addAirport { id in
            router.navigate(to: .airportDetails(id))
        }
    }
}

private extension AirportsListView {
    var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                router.navigate(to: .settings)
            } label: {
                Image(systemName: "gearshape")
            }
            .accessibilityLabel("Settings")
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
                .font(.caption)
                .foregroundStyle(.secondary)
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
