//
//  MockAppSettings.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation
@testable import WeatherReport

@MainActor
final class MockAppSettings: AppSettingsProviding {
    var autoRefreshEnabled: Bool
    var autoRefreshIntervalSeconds: UInt64
    var cacheMaxAge: UInt64

    init(
        autoRefreshEnabled: Bool = false,
        autoRefreshIntervalSeconds: UInt64 = 30,
        cacheMaxAge: UInt64 = 300
    ) {
        self.autoRefreshEnabled = autoRefreshEnabled
        self.autoRefreshIntervalSeconds = autoRefreshIntervalSeconds
        self.cacheMaxAge = cacheMaxAge
    }
}
