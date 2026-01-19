//
//  AppNavigationDestinations.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

struct AppNavigationDestinations: ViewModifier {
    let dependencies: AppDependencies

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                destination(for: route)
            }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .airportDetails(let id):
            WeatherDetailsView(
                airportIdentifier: id,
                weatherService: dependencies.weatherService
            )
        }
    }
}

extension View {
    func appDestinations(_ dependencies: AppDependencies) -> some View {
        modifier(AppNavigationDestinations(dependencies: dependencies))
    }
}
