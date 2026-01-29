//
//  AppDependencies.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

enum AppConfigurationError: Error, CustomStringConvertible, Sendable {
    case invalidBaseURL(String)

    var description: String {
        switch self {
        case .invalidBaseURL(let value):
            return "Invalid base URL string: \(value)"
        }
    }
}

/// Composition Root for dependency injection
@MainActor
final class AppDependencies {
    let airportsStorage: AirportsStorage
    let appSettings: AppSettings
    let weatherRepository: WeatherRepository
    let weatherService: WeatherService
    let coding: JSONCoding

    init(
        httpClient: HTTPClient = DefaultHTTPClient(),
        userDefaults: UserDefaults = .standard,
        baseURLString: String = ForeFlightConfig.baseURLString
    ) throws {
        self.coding = DefaultJSONCoding()

        guard let baseURL = URL(string: baseURLString) else {
            throw AppConfigurationError.invalidBaseURL(baseURLString)
        }

        self.airportsStorage = AirportsStorage(defaults: userDefaults)
        self.appSettings = AppSettings(defaults: userDefaults)

        let apiClient = APIClient(baseURL: baseURL, httpClient: httpClient)
        self.weatherService = LiveWeatherService(client: apiClient)

        let cacheStore = Self.makeCacheStore(coding: coding)
        self.weatherRepository = DefaultWeatherRepository(
            live: weatherService,
            cache: cacheStore,
            coding: coding
        )
    }
    
    private static func makeCacheStore(coding: JSONCoding) -> WeatherCacheStoring {
        if let store = try? FileWeatherCacheStore(coding: coding) {
            return store
        } else {
            return InMemoryWeatherCacheStore()
        }
    }
}
