//
//  WeatherDetailsView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

struct WeatherDetailsView: View {
    @State private var viewModel: WeatherDetailsViewModel

    init(airportIdentifier: String, weatherService: WeatherServiceProtocol) {
        _viewModel = State(
            wrappedValue: WeatherDetailsViewModel(
                airportIdentifier: airportIdentifier,
                weatherService: weatherService
            )
        )
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 0) {
            header
        
            Picker("", selection: $viewModel.selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            content(for: viewModel)
        }
        .navigationTitle(viewModel.airportIdentifier)
        .task { viewModel.onAppear() }
        .refreshable { viewModel.refresh() }
    }

    @ViewBuilder
    private func content(for viewModel: WeatherDetailsViewModel) -> some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .failed(let message):
            ContentUnavailableView {
                Label("Błąd", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Spróbuj ponownie") { viewModel.refresh() }
            }
            
        case .loaded:
            ScrollView {
                switch viewModel.selectedTab {
                case .conditions:
                    if let data = viewModel.conditions {
                        ConditionsView(conditionsViewData: data)
                    }
                case .forecast:
                    if let data = viewModel.forecast {
                        ForecastView(forecastViewData: data)
                    }
                }
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 4) {
            Text(viewModel.airportIdentifier)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Last updated: --")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Detail Tab

enum DetailTab: CaseIterable {
    case conditions
    case forecast
    
    var title: String {
        switch self {
        case .conditions: return "Conditions"
        case .forecast: return "Forecast"
        }
    }
}

#Preview {
    NavigationStack {
        WeatherDetailsView(airportIdentifier: "KPWM", weatherService: MockWeatherService(mode: .success(WeatherReportDTO.mockKPWM())))
    }
}
