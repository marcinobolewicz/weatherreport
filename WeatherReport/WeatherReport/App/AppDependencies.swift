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
    let airportsStorage: AirportsStorage
    let appSettings: AppSettings
    let weatherRepository: WeatherRepository
    let weatherService: WeatherService
    let coding: JSONCoding
    
    init(
        httpClient: HTTPClient = DefaultHTTPClient(),
        userDefaults: UserDefaults = .standard
    ) {
        self.airportsStorage = AirportsStorage(defaults: userDefaults)
        self.appSettings = AppSettings(defaults: userDefaults)
        self.weatherService = LiveWeatherService(httpClient: httpClient)
        self.coding = DefaultJSONCoding()
        
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
