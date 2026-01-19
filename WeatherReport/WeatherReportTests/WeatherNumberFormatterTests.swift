//
//  WeatherNumberFormatterTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Testing
@testable import WeatherReport

@Suite("WeatherNumberFormatter Tests")
struct WeatherNumberFormatterTests {
    
    let formatter = WeatherNumberFormatter()
    
    // MARK: - formatOneDecimal
    
    @Test("formatOneDecimal returns integer when decimal is zero")
    func formatOneDecimalReturnsIntegerWhenDecimalIsZero() {
        #expect(formatter.formatOneDecimal(10.0) == "10")
        #expect(formatter.formatOneDecimal(0.0) == "0")
        #expect(formatter.formatOneDecimal(-5.0) == "-5")
    }
    
    @Test("formatOneDecimal keeps one decimal place when non-zero")
    func formatOneDecimalKeepsOneDecimalPlaceWhenNonZero() {
        #expect(formatter.formatOneDecimal(10.5) == "10.5")
        #expect(formatter.formatOneDecimal(3.14) == "3.1")
        #expect(formatter.formatOneDecimal(-2.7) == "-2.7")
    }
    
    @Test("formatOneDecimal handles edge cases")
    func formatOneDecimalHandlesEdgeCases() {
        #expect(formatter.formatOneDecimal(0.1) == "0.1")
        #expect(formatter.formatOneDecimal(0.05) == "0.1") // rounds up
        #expect(formatter.formatOneDecimal(0.04) == "0") // rounds down to 0.0 -> "0"
    }
    
    // MARK: - roundToInt
    
    @Test("roundToInt rounds correctly")
    func roundToIntRoundsCorrectly() {
        #expect(formatter.roundToInt(10.4) == 10)
        #expect(formatter.roundToInt(10.5) == 11)
        #expect(formatter.roundToInt(10.6) == 11)
        #expect(formatter.roundToInt(-2.4) == -2)
        #expect(formatter.roundToInt(-2.5) == -3) // banker's rounding
        #expect(formatter.roundToInt(-2.6) == -3)
    }
}
