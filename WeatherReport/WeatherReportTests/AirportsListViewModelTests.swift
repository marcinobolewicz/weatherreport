//
//  AirportsListViewModelTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("AirportsListViewModel Tests")
@MainActor
struct AirportsListViewModelTests {
    
    // MARK: - airports
    
    @Test("airports returns storage airports")
    func airportsReturnsStorageAirports() {
        let storage = MockAirportsStorage(airports: ["KPWM", "KAUS"])
        let viewModel = AirportsListViewModel(storage: storage)
        
        #expect(viewModel.airports == ["KPWM", "KAUS"])
    }
    
    // MARK: - normalizedAirportCode
    
    @Test("normalizedAirportCode trims and uppercases input")
    func normalizedAirportCodeTrimsAndUppercases() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        
        viewModel.newAirportText = "  kpwm  "
        
        #expect(viewModel.normalizedAirportCode == "KPWM")
    }
    
    @Test("normalizedAirportCode handles empty string")
    func normalizedAirportCodeHandlesEmptyString() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        
        viewModel.newAirportText = "   "
        
        #expect(viewModel.normalizedAirportCode == "")
    }
    
    // MARK: - canAddAirport
    
    @Test("canAddAirport returns true for 4-character code")
    func canAddAirportReturnsTrueFor4Characters() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        
        viewModel.newAirportText = "KPWM"
        
        #expect(viewModel.canAddAirport == true)
    }
    
    @Test("canAddAirport returns false for non-4-character code")
    func canAddAirportReturnsFalseForNon4Characters() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        
        viewModel.newAirportText = "KPW"
        #expect(viewModel.canAddAirport == false)
        
        viewModel.newAirportText = "KPWMX"
        #expect(viewModel.canAddAirport == false)
        
        viewModel.newAirportText = ""
        #expect(viewModel.canAddAirport == false)
    }
    
    // MARK: - addAirport
    
    @Test("addAirport adds normalized airport and clears text")
    func addAirportAddsNormalizedAirportAndClearsText() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        var navigatedTo: String?
        
        viewModel.newAirportText = "  kpwm  "
        viewModel.addAirport { navigatedTo = $0 }
        
        #expect(storage.addedAirports == ["KPWM"])
        #expect(viewModel.newAirportText == "")
        #expect(navigatedTo == "KPWM")
    }
    
    @Test("addAirport does not add empty identifier")
    func addAirportDoesNotAddEmptyIdentifier() {
        let storage = MockAirportsStorage()
        let viewModel = AirportsListViewModel(storage: storage)
        var navigateCalled = false
        
        viewModel.newAirportText = "   "
        viewModel.addAirport { _ in navigateCalled = true }
        
        #expect(storage.addedAirports.isEmpty)
        #expect(navigateCalled == false)
    }
    
    // MARK: - removeAirports
    
    @Test("removeAirports removes airports at offsets")
    func removeAirportsRemovesAtOffsets() {
        let storage = MockAirportsStorage(airports: ["KPWM", "KAUS", "KJFK"])
        let viewModel = AirportsListViewModel(storage: storage)
        
        viewModel.removeAirports(at: IndexSet([0, 2]))
        
        #expect(storage.removedOffsets.count == 1)
        #expect(storage.removedOffsets[0] == IndexSet([0, 2]))
    }
}
