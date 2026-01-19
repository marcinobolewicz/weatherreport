//
//  WeatherTextFormatterTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("WeatherTextFormatter Tests")
struct WeatherTextFormatterTests {
    
    // Uses real WeatherDateFormatter and WeatherNumberFormatter
    private let formatter = WeatherTextFormatter()
    
    // MARK: - makeConditionsViewData
    
    @Test("makeConditionsViewData formats all fields correctly")
    func makeConditionsViewDataFormatsCorrectly() async {
        let formatter = WeatherTextFormatter()
        
        let model = ConditionsModel(
            title: "KPWM",
            issuedAt: Date(timeIntervalSince1970: 1_736_000_000),
            flightRules: "vfr",
            wind: WindModel(directionDegrees: 260, speedKts: 12.0, gustKts: 18.0),
            visibility: VisibilityModel(distanceSm: 10.0, qualifier: nil),
            temperatureC: 2.5,
            dewpointC: -3.0,
            pressureHpa: 1013.2,
            cloudLayers: [
                CloudLayerModel(coverage: "few", altitudeFt: 2000),
                CloudLayerModel(coverage: "sct", altitudeFt: 5000)
            ],
            rawMETAR: "KPWM 161651Z 26012G18KT 10SM FEW020 SCT050 02/M03 A2992"
        )
        
        let result = await formatter.makeConditionsViewData(from: model)
        
        #expect(result.title == "KPWM")
        #expect(result.lastUpdatedText.contains("Z)"))
        #expect(result.flightRulesText == "VFR")
        #expect(result.windText == "260° 12G18 kt")
        #expect(result.visibilityText == "10 SM")
        #expect(result.temperatureText == "2.5°C")
        #expect(result.dewpointText == "-3°C")
        #expect(result.pressureText == "1013.2 hPa")
        #expect(result.cloudsText == "FEW 2000 • SCT 5000")
        #expect(result.rawMETARText == "KPWM 161651Z 26012G18KT 10SM FEW020 SCT050 02/M03 A2992")
    }
    
    @Test("makeConditionsViewData handles wind without gusts")
    func makeConditionsViewDataHandlesWindWithoutGusts() async {
        let formatter = WeatherTextFormatter()
        
        let model = ConditionsModel(
            title: "KAUS",
            issuedAt: Date(),
            flightRules: "mvfr",
            wind: WindModel(directionDegrees: 180, speedKts: 8.0, gustKts: nil),
            visibility: VisibilityModel(distanceSm: 5.0, qualifier: nil),
            temperatureC: 20.0,
            dewpointC: 15.0,
            pressureHpa: 1015.0,
            cloudLayers: [],
            rawMETAR: "RAW"
        )
        
        let result = await formatter.makeConditionsViewData(from: model)
        
        #expect(result.windText == "180° 8 kt")
        #expect(result.cloudsText == "--")
    }
    
    @Test("makeConditionsViewData handles P6SM visibility qualifier")
    func makeConditionsViewDataHandlesVisibilityQualifier() async {
        let formatter = WeatherTextFormatter()
        
        let model = ConditionsModel(
            title: "TEST",
            issuedAt: Date(),
            flightRules: "vfr",
            wind: WindModel(directionDegrees: 0, speedKts: 5.0, gustKts: nil),
            visibility: VisibilityModel(distanceSm: 6.0, qualifier: 1),
            temperatureC: 10.0,
            dewpointC: 5.0,
            pressureHpa: 1010.0,
            cloudLayers: [],
            rawMETAR: "RAW"
        )
        
        let result = await formatter.makeConditionsViewData(from: model)
        
        #expect(result.visibilityText == "P6 SM")
    }
    
    // MARK: - makeForecastViewData
    
    @Test("makeForecastViewData formats periods correctly")
    func makeForecastViewDataFormatsPeriods() async {
        let formatter = WeatherTextFormatter()
        
        let start = Date(timeIntervalSince1970: 1_736_000_000)
        let end = Date(timeIntervalSince1970: 1_736_021_600)
        
        let model = ForecastModel(
            periods: [
                ForecastPeriodModel(
                    period: PeriodModel(start: start, end: end),
                    flightRules: "vfr",
                    wind: WindModel(directionDegrees: 250, speedKts: 12.0, gustKts: 20.0),
                    visibility: VisibilityModel(distanceSm: 6.0, qualifier: 1)
                )
            ],
            rawTAF: "TAF KPWM..."
        )
        
        let result = await formatter.makeForecastViewData(from: model)
        
        #expect(result.periods.count == 1)
        #expect(result.periods[0].title == "Period 1")
        #expect(!result.periods[0].timeRangeText.isEmpty)
        #expect(result.periods[0].flightRulesText == "VFR")
        #expect(result.periods[0].windText == "250° 12G20 kt")
        #expect(result.periods[0].visibilityText == "P6 SM")
        #expect(result.rawTAFText == "TAF KPWM...")
    }
    
    @Test("makeForecastViewData handles nil period")
    func makeForecastViewDataHandlesNilPeriod() async {
        let formatter = WeatherTextFormatter()
        
        let model = ForecastModel(
            periods: [
                ForecastPeriodModel(
                    period: nil,
                    flightRules: "ifr",
                    wind: WindModel(directionDegrees: 90, speedKts: 5.0, gustKts: nil),
                    visibility: VisibilityModel(distanceSm: 2.0, qualifier: nil)
                )
            ],
            rawTAF: "TAF"
        )
        
        let result = await formatter.makeForecastViewData(from: model)
        
        #expect(result.periods[0].timeRangeText == "")
        #expect(result.periods[0].flightRulesText == "IFR")
    }
}
