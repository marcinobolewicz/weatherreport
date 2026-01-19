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
    
    // MARK: - Initial State
    
    @Test("initial state is idle")
    func initialStateIsIdle() {
        let mockService = MockWeatherService(mode: .success(.mockKPWM()))
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        #expect(viewModel.state == .idle)
        #expect(viewModel.conditions == nil)
        #expect(viewModel.forecast == nil)
    }
    
    // MARK: - onAppear
    
    @Test("onAppear triggers loading and populates data")
    func onAppearTriggersLoadingAndPopulatesData() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let mockService = MockWeatherService(mode: .success(dto))
        
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        viewModel.onAppear()
        
        // Wait for async task to complete
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.state == .loaded)
        #expect(viewModel.conditions != nil)
        #expect(viewModel.forecast != nil)
    }
    
    @Test("onAppear does nothing if not idle")
    func onAppearDoesNothingIfNotIdle() async throws {
        let mockService = MockWeatherService(mode: .success(.mockKPWM()))
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        // First call
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Change conditions to detect if refresh happens
        let previousConditions = viewModel.conditions
        
        // Second call should be ignored
        viewModel.onAppear()
        try await Task.sleep(nanoseconds: 50_000_000)
        
        #expect(viewModel.conditions == previousConditions)
    }
    
    // MARK: - refresh
    
    @Test("refresh loads data successfully with real presenter")
    func refreshLoadsDataSuccessfully() async throws {
        let dto = WeatherReportDTO.mockKPWM()
        let mockService = MockWeatherService(mode: .success(dto))
        
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
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
        let mockService = MockWeatherService(mode: .failure(NetworkError.noData))
        
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        viewModel.refresh()
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.state == .failed(message: "Load failed"))
    }
    
    // MARK: - selectedTab
    
    @Test("selectedTab defaults to conditions")
    func selectedTabDefaultsToConditions() {
        let mockService = MockWeatherService(mode: .success(.mockKPWM()))
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        #expect(viewModel.selectedTab == .conditions)
    }
    
    @Test("selectedTab can be changed")
    func selectedTabCanBeChanged() {
        let mockService = MockWeatherService(mode: .success(.mockKPWM()))
        let viewModel = WeatherDetailsViewModel(
            airportIdentifier: "KPWM",
            weatherService: mockService
        )
        
        viewModel.selectedTab = .forecast
        
        #expect(viewModel.selectedTab == .forecast)
    }
}
