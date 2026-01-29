//
//  WeatherReportApp.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

@main
struct WeatherReportApp: App {
    private let dependencies: AppDependencies
    @State private var router = AppRouter()
    
    init() {
        do {
            dependencies = try AppDependencies()
        } catch let configError as AppConfigurationError {
            fatalError("App configuration failed: \(configError)")
        } catch {
            fatalError("Unexpected error while creating AppDependencies: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
                .environment(router)
        }
    }
}
