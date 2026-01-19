//
//  WeatherDetailsViewModel.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

@Observable
@MainActor
final class WeatherDetailsViewModel {
    let airportIdentifier: String
    private let weatherService: WeatherServiceProtocol
    private let presenter: WeatherDetailsPresenting
    var selectedTab: DetailTab = .conditions
    
    var state: LoadState = .idle
    var conditions: ConditionsViewData?
    var forecast: ForecastViewData?
    private var loadTask: Task<Void, Never>?
    
    init(airportIdentifier: String, weatherService: WeatherServiceProtocol, presenter: WeatherDetailsPresenting = WeatherDetailsPresenter()) {
        self.airportIdentifier = airportIdentifier
        self.weatherService = weatherService
        self.presenter = presenter
    }
    
    func onAppear() {
        guard state == .idle else { return }
        refresh()
    }

    func refresh() {
        loadTask?.cancel()

        loadTask = Task { [airportIdentifier] in
            await load(airportIdentifier: airportIdentifier)
        }
    }

    private func load(airportIdentifier: String) async {
        state = .loading

        do {
            let dto = try await weatherService.fetchReport(for: airportIdentifier)

            async let conditionsViewData = presenter.makeConditions(from: dto)
            async let forecastViewData  = presenter.makeForecast(from: dto)

            let (conditions, forecast) = await (conditionsViewData, forecastViewData)

            self.conditions = conditions
            self.forecast = forecast
            self.state = .loaded
        } catch is CancellationError {
        } catch {
            self.state = .failed(message: userFacingMessage(for: error))
        }
    }

    private func userFacingMessage(for error: Error) -> String {
        // TODO: error mapping
        return "Load failed"
    }
}
