//
//  SettingsView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 22/01/2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel

    init(appSettings: AppSettings, weatherRepository: WeatherRepository) {
        _viewModel = State(
            wrappedValue: SettingsViewModel(
                appSettings: appSettings,
                weatherRepository: weatherRepository
            )
        )
    }

    var body: some View {
        List {
            cacheSection
            autoRefreshSection
        }
        .navigationTitle("Settings")
        .alert("Error", isPresented: $viewModel.isErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}

private extension SettingsView {
    var cacheSection: some View {
        Section("Cache") {
            Button(role: .destructive) {
                Task {
                    await viewModel.clearCache()
                }
            } label: {
                HStack {
                    Text("Clear cache")
                    Spacer()
                    if viewModel.isClearingCache {
                        ProgressView()
                    }
                }
            }
            .disabled(viewModel.isClearingCache)
        }
    }

    var autoRefreshSection: some View {
        Section("Auto refresh") {
            Toggle("Refresh Enabled", isOn: $viewModel.autoRefreshEnabled)
            
            VStack(alignment: .leading, spacing: 12) {
                Text(intervalLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Slider(value: $viewModel.autoRefreshIntervalSeconds, in: 10...60, step: 1)
                    .accessibilityValue("\(Int(viewModel.autoRefreshIntervalSeconds)) seconds")
            }
        }
    }

    var intervalLabel: String {
        "Interval: \(Int(viewModel.autoRefreshIntervalSeconds)) s"
    }
}
