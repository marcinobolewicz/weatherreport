//
//  WeatherReportApp.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

@main
struct WeatherReportApp: App {
    
    @State private var router = AppRouter()
    @State private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            AirportsListView(storage: dependencies.airportsStorage)
                .environment(router)
        }
    }
}
