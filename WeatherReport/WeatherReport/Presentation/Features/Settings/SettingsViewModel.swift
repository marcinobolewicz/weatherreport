//
//  SettingsViewModel.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 22/01/2026.
//

import SwiftUI

@Observable
@MainActor
final class SettingsViewModel {
    private var appSettings: AppSettingsProviding
    private let weatherRepository: WeatherRepository
    
    var autoRefreshEnabled: Bool {
        get {
            appSettings.autoRefreshEnabled
        }
        set {
            appSettings.autoRefreshEnabled = newValue
        }
    }
    
    var autoRefreshIntervalSeconds: Double {
        get {
            Double(appSettings.autoRefreshIntervalSeconds)
        }
        set {
            appSettings.autoRefreshIntervalSeconds = UInt64(newValue)
        }
    }
    
    var isClearingCache: Bool = false
    var errorMessage: String?
    var isErrorPresented: Bool = false
    
    init(
        appSettings: AppSettingsProviding,
        weatherRepository: WeatherRepository,
    ) {
        self.appSettings = appSettings
        self.weatherRepository = weatherRepository
    }
    
    func clearCache() async {
        guard !isClearingCache else { return }

        isClearingCache = true
        errorMessage = nil
        isErrorPresented = false

        defer { isClearingCache = false }

        do {
            try await weatherRepository.clearCache()
        } catch is CancellationError {
        } catch {
            errorMessage = error.localizedDescription
            isErrorPresented = true
        }
    }
}
