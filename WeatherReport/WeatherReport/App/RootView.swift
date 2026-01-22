//
//  RootView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

struct RootView: View {
    private let dependencies: AppDependencies
    @Environment(AppRouter.self) private var router
    @State private var airportsListViewModel: AirportsListViewModel

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _airportsListViewModel = State(wrappedValue: AirportsListViewModel(storage: dependencies.airportsStorage))
    }

    var body: some View {
        @Bindable var router = router
        
        NavigationStack(path: $router.path) {
            AirportsListView(viewModel: airportsListViewModel)
                .navigationTitle("Airports")
                .appDestinations(dependencies)
        }
        .environment(router)
    }
}
