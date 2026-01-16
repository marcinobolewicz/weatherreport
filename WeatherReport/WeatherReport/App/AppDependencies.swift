//
//  AppDependencies.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

/// Composition Root for dependency injection
@MainActor
final class AppDependencies {
    
    let weatherService: WeatherServiceProtocol
    let airportsStorage: AirportsStorage
    
    init(
        httpClient: HTTPClientProtocol = HTTPClient(),
        userDefaults: UserDefaults = .standard
    ) {
        self.weatherService = WeatherService(httpClient: httpClient)
        self.airportsStorage = AirportsStorage(defaults: userDefaults)
    }
}
