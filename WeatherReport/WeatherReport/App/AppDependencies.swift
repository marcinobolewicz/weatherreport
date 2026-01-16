//
//  AppDependencies.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

/// Composition Root for dependency injection
final class AppDependencies {
    
    let weatherService: WeatherServiceProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient()) {
        self.weatherService = WeatherService(httpClient: httpClient)
    }
}
