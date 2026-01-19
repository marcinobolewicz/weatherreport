//
//  WeatherDateFormatter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

protocol WeatherDateFormatting: Actor {
    func formatZuluTime(_ date: Date) -> String
    func formatZuluRange(_ start: Date, _ end: Date) -> String
}

actor WeatherDateFormatter: WeatherDateFormatting {
    private let zuluTimeFormatter: DateFormatter
    private let zuluRangeFormatter: DateIntervalFormatter

    init() {
        let timeFormatter = DateFormatter()
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        timeFormatter.dateFormat = "HH:mm'Z'"
        self.zuluTimeFormatter = timeFormatter

        let rangeFormatter = DateIntervalFormatter()
        rangeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        rangeFormatter.dateTemplate = "d MMM HH:mm'Z'"
        self.zuluRangeFormatter = rangeFormatter
    }

    func formatZuluTime(_ date: Date) -> String {
        zuluTimeFormatter.string(from: date)
    }

    func formatZuluRange(_ start: Date, _ end: Date) -> String {
        zuluRangeFormatter.string(from: start, to: end)
    }
}
