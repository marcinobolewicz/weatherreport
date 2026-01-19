//
//  WeatherNumberFormatter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

protocol WeatherNumberFormatting: Sendable {
    func formatOneDecimal(_ value: Double) -> String
    func roundToInt(_ value: Double) -> Int
}

struct WeatherNumberFormatter: WeatherNumberFormatting {
    func formatOneDecimal(_ value: Double) -> String {
        let formatted = String(format: "%.1f", value)
        return formatted.hasSuffix(".0") ? String(formatted.dropLast(2)) : formatted
    }

    func roundToInt(_ value: Double) -> Int {
        Int(value.rounded())
    }
}
