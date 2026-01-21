//
//  AppSettings.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import SwiftUI

@MainActor
protocol AppSettingsProviding {
    var autoRefreshEnabled: Bool { get set }
    var autoRefreshIntervalSeconds: UInt64 { get set }
    var cacheMaxAge: UInt64 { get set }
}

@Observable
final class AppSettings: AppSettingsProviding {
    private enum Constants {
        static let defaultInterval: UInt64 = 30
        static let defaultCacheMaxAge: UInt64 = 600
    }
    private enum Keys {
        static let enabled = "auto_refresh_enabled"
        static let interval = "auto_refresh_interval_seconds"
        static let maxAge = "max_cache_age_seconds"
    }

    private let defaults: UserDefaults

    var autoRefreshEnabled: Bool {
        get { defaults.bool(forKey: Keys.enabled) }
        set { defaults.set(newValue, forKey: Keys.enabled) }
    }

    var autoRefreshIntervalSeconds: UInt64 {
        get {
            let v = defaults.integer(forKey: Keys.interval)
            return v > 0 ? UInt64(v) : Constants.defaultInterval
        }
        set { defaults.set(Int(newValue), forKey: Keys.interval) }
    }

    var cacheMaxAge: UInt64 {
        get {
            let v = defaults.integer(forKey: Keys.maxAge)
            return v > 0 ? UInt64(v) : Constants.defaultCacheMaxAge
        }
        set { defaults.set(Int(newValue), forKey: Keys.maxAge) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        defaults.register(defaults: [
            Keys.interval: Int(Constants.defaultInterval),
            Keys.maxAge: Int(Constants.defaultCacheMaxAge),
            Keys.enabled: true
        ])
    }
}
