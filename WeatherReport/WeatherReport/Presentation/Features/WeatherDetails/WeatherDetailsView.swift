//
//  WeatherDetailsView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

struct WeatherDetailsView: View {
    @State private var viewModel: WeatherDetailsViewModel

    init(
        airportIdentifier: String,
        appSettings: AppSettings,
        weatherRepository: WeatherRepository
    ) {
        _viewModel = State(
            wrappedValue: WeatherDetailsViewModel(
                airportIdentifier: airportIdentifier,
                appSettings: appSettings,
                weatherRepository: weatherRepository
            )
        )
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        VStack(spacing: 0) {
            header
            
            infoMessage()
        
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
        .onDisappear { viewModel.onDisappear() }
    }
    
    @ViewBuilder
    private func infoMessage() -> some View {
        if let message = viewModel.infoMessage {
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.top, 4)
        }
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
            
            Text("Last updated: \(viewModel.reportDate ?? "--")")
                .font(.caption)
                .foregroundStyle(viewModel.maxAgeExceeded ? .red : .secondary)
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
    let settings = AppSettings()
    let mockService = MockWeatherService(mode: .success(.mockKPWM()))
    let cache = InMemoryWeatherCacheStore()

    let repository = DefaultWeatherRepository(
        live: mockService,
        cache: cache,
        coding: DefaultJSONCoding()
    )

    WeatherDetailsView(
        airportIdentifier: "KPWM",
        appSettings: settings,
        weatherRepository: repository
    )
}
