//
//  AirportsStorageTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("AirportsStorage Tests")
@MainActor
struct AirportsStorageTests {
    
    // MARK: - Initial State
    
    @Test("Seeds default airports when UserDefaults is empty")
    func seedsDefaultAirports() {
        let sut = AirportsStorage(defaults: .makeMock())
        
        #expect(sut.airports.count == 2)
        #expect(sut.airports.contains("KPWM"))
        #expect(sut.airports.contains("KAUS"))
    }
    
    @Test("Loads existing airports from UserDefaults")
    func loadsExistingAirports() {
        let defaults = UserDefaults.makeMock()
        defaults.set(["KJFK", "KLAX"], forKey: "saved_airports")
        
        let sut = AirportsStorage(defaults: defaults)
        
        #expect(sut.airports == ["KJFK", "KLAX"])
    }
    
    // MARK: - Add Airport
    
    @Test("Adds airport with normalized identifier")
    func addsNormalizedAirport() {
        let sut = AirportsStorage(defaults: .makeMock())
        
        let result = sut.add("  kjfk  ")
        
        #expect(result == true)
        #expect(sut.airports.contains("KJFK"))
    }
    
    @Test("Does not add duplicate airport")
    func doesNotAddDuplicate() {
        let sut = AirportsStorage(defaults: .makeMock())
        let initialCount = sut.airports.count
        
        let result = sut.add("KPWM")
        
        #expect(result == false)
        #expect(sut.airports.count == initialCount)
    }
    
    @Test("Does not add empty identifier")
    func doesNotAddEmpty() {
        let sut = AirportsStorage(defaults: .makeMock())
        let initialCount = sut.airports.count
        
        let result = sut.add("   ")
        
        #expect(result == false)
        #expect(sut.airports.count == initialCount)
    }
    
    @Test("Persists added airport to UserDefaults")
    func persistsAddedAirport() {
        let defaults = UserDefaults.makeMock()
        let sut = AirportsStorage(defaults: defaults)
        
        sut.add("KJFK")
        
        let saved = defaults.stringArray(forKey: "saved_airports")
        #expect(saved?.contains("KJFK") == true)
    }
    
    // MARK: - Remove Airport
    
    @Test("Removes airport at valid index")
    func removesAirportAtIndex() {
        let sut = AirportsStorage(defaults: .makeMock())
        let airportToRemove = sut.airports[0]
        
        sut.remove(at: IndexSet(integer: 0))
        
        #expect(!sut.airports.contains(airportToRemove))
    }
    
    @Test("Persists removal to UserDefaults")
    func persistsRemoval() {
        let defaults = UserDefaults.makeMock()
        let sut = AirportsStorage(defaults: defaults)
        let airportToRemove = sut.airports[0]
        
        sut.remove(at: IndexSet(integer: 0))
        
        let saved = defaults.stringArray(forKey: "saved_airports")
        #expect(saved?.contains(airportToRemove) == false)
    }
    
    // MARK: - Contains
    
    @Test("Contains returns true for existing airport")
    func containsExistingAirport() {
        let sut = AirportsStorage(defaults: .makeMock())
        
        #expect(sut.contains("KPWM") == true)
        #expect(sut.contains("kpwm") == true) // case insensitive
    }
    
    @Test("Contains returns false for non-existing airport")
    func doesNotContainNonExisting() {
        let sut = AirportsStorage(defaults: .makeMock())
        
        #expect(sut.contains("XXXX") == false)
    }
}
