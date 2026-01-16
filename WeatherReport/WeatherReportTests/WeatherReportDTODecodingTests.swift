//
//  WeatherReportDTODecodingTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation
import Testing
@testable import WeatherReport

struct WeatherReportDTODecodingTests {
    
    @Test func decodesValidJSON() throws {
        let dto = try TestFixtures.loadWeatherReportDTO()
        
        #expect(dto.report.conditions.ident == "kpwm")
    }
    
    @Test func decodesConditionsCorrectly() throws {
        let conditions = try TestFixtures.loadWeatherReportDTO().report.conditions
        
        #expect(conditions.ident == "kpwm")
        #expect(conditions.flightRules == "vfr")
        #expect(conditions.tempC == -7.0)
        #expect(conditions.dewpointC == -14.0)
        #expect(abs(conditions.pressureHpa - 996.655779) < 0.0001)
    }
    
    @Test func decodesRawMETARText() throws {
        let conditions = try TestFixtures.loadWeatherReportDTO().report.conditions
        
        #expect(conditions.text.contains("METAR KPWM"))
        #expect(conditions.text.contains("28017G27KT"))
    }
    
    @Test func decodesDateIssued() throws {
        let conditions = try TestFixtures.loadWeatherReportDTO().report.conditions
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: TimeZone(identifier: "UTC")!, from: conditions.dateIssued)
        
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 16)
        #expect(components.hour == 12)
        #expect(components.minute == 51)
    }
    
    @Test func decodesWindCorrectly() throws {
        let wind = try TestFixtures.loadWeatherReportDTO().report.conditions.wind
        
        #expect(wind.direction == 280)
        #expect(wind.speedKts == 17.0)
        #expect(wind.gustSpeedKts == 27.0)
    }
    
    @Test func decodesVisibilityCorrectly() throws {
        let visibility = try TestFixtures.loadWeatherReportDTO().report.conditions.visibility
        
        #expect(visibility.distanceSm == 10.0)
    }
    
    @Test func decodesCloudLayersCorrectly() throws {
        let cloudLayers = try TestFixtures.loadWeatherReportDTO().report.conditions.cloudLayers
        
        #expect(cloudLayers.count == 2)
        
        #expect(cloudLayers[0].coverage == "few")
        #expect(cloudLayers[0].altitudeFt == 3800.0)
        #expect(cloudLayers[0].ceiling == false)
        
        #expect(cloudLayers[1].coverage == "bkn")
        #expect(cloudLayers[1].altitudeFt == 4900.0)
        #expect(cloudLayers[1].ceiling == true)
    }
    
    @Test func decodesEmptyWeatherArray() throws {
        let weather = try TestFixtures.loadWeatherReportDTO().report.conditions.weather
        
        #expect(weather.isEmpty)
    }
}
