//
//  AppRouter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

enum Route: Hashable {
    case airportDetails(String)
}

@Observable
final class AppRouter {
    var path = NavigationPath()

    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
