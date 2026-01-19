//
//  WeatherDateFormatterTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("WeatherDateFormatter Tests")
struct WeatherDateFormatterTests {
    
    let formatter = WeatherDateFormatter(
        locale: Locale(identifier: "en_US_POSIX"),
        calendar: Calendar(identifier: .gregorian),
        timeZone: .gmt
    )
        
    
    // MARK: - formatZuluTime
    
    @Test("formatZuluTime formats date in Zulu time")
    func formatZuluTimeFormatsCorrectly() async {
        // 2025-01-04 16:30:00 UTC
        let date = Date(timeIntervalSince1970: 1_736_000_000)
        
        let result = await formatter.formatZuluTime(date)
        
        #expect(result == "14:13Z")
    }
    
    @Test("formatZuluTime handles midnight")
    func formatZuluTimeHandlesMidnight() async {
        // 2025-01-01 00:00:00 UTC
        let date = Date(timeIntervalSince1970: 1_735_689_600)
        
        let result = await formatter.formatZuluTime(date)
        
        #expect(result == "00:00Z")
    }
    
    // MARK: - formatZuluRange
    
    @Test("formatZuluRange formats date range")
    func formatZuluRangeFormatsCorrectly() async {
        let start = Date(timeIntervalSince1970: 1_736_000_000)
        let end = Date(timeIntervalSince1970: 1_736_086_400)
        
        let result = await formatter.formatZuluRange(start, end)
        
        #expect(result == "Jan 4 at 14:13 – Jan 5 at 14:13")
    }
}
