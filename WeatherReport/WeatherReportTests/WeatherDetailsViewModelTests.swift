//
//  WeatherDetailsViewModelTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("WeatherDetailsViewModel Tests")
@MainActor
struct WeatherDetailsViewModelTests {
    
    private func makeViewModel(
        airportIdentifier: String = "KPWM",
        serviceMode: MockWeatherService.Mode
    ) -> WeatherDetailsViewModel {
        let mockService = MockWeatherService(mode: serviceMode)
        let repository = DefaultWeatherRepository(
            live: mockService,
            cache: InMemoryWeatherCacheStore(),
            coding: DefaultJSONCoding()
        )
        let settings = MockAppSettings()
        return WeatherDetailsViewModel(
            airportIdentifier: airportIdentifier,
            appSettings: settings,
            weatherRepository: repository
        )
    }

    // MARK: - Initial State
    
    @Test("initial state is idle")
    func initialStateIsIdle() {
        let viewModel = makeViewModel(serviceMode: .success(.mockKPWM()))
        
        #expect(viewModel.state == .idle)
        #expect(viewModel.conditions == nil)
        #expect(viewModel.forecast == nil)
    }
    
    // MARK: - onAppear
    
    @Test("onAppear triggers loading and populates data")
    func onAppearTriggersLoadingAndPopulatesData() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let viewModel = makeViewModel(serviceMode: .success(dto))
        
        viewModel.onAppear()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.state == .loaded)
        #expect(viewModel.conditions != nil)
        #expect(viewModel.forecast != nil)
    }

    // MARK: - refresh
    
    @Test("refresh loads data successfully with real presenter")
    func refreshLoadsDataSuccessfully() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let viewModel = makeViewModel(serviceMode: .success(dto))
        
        viewModel.refresh()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.state == .loaded)
        #expect(viewModel.conditions?.title == "KPWM")
        #expect(viewModel.conditions?.flightRulesText == "VFR")
        #expect(viewModel.conditions?.windText == "260° 12G18 kt")
        #expect(viewModel.conditions?.visibilityText == "10 SM")
        #expect(viewModel.conditions?.temperatureText == "2°C")
        #expect(viewModel.conditions?.dewpointText == "-3°C")
        #expect(viewModel.forecast != nil)
    }
    
    @Test("refresh sets failed state on error")
    func refreshSetsFailedStateOnError() async throws {
        let viewModel = makeViewModel(serviceMode: .failure(NetworkError.noData))
        
        viewModel.refresh()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.state == .failed(message: "Load failed"))
    }
    
    // MARK: - selectedTab
    
    @Test("selectedTab defaults to conditions")
    func selectedTabDefaultsToConditions() {
        let viewModel = makeViewModel(serviceMode: .success(.mockKPWM()))
        
        #expect(viewModel.selectedTab == .conditions)
    }
    
    @Test("selectedTab can be changed")
    func selectedTabCanBeChanged() {
        let viewModel = makeViewModel(serviceMode: .success(.mockKPWM()))
        
        viewModel.selectedTab = .forecast
        
        #expect(viewModel.selectedTab == .forecast)
    }
}
