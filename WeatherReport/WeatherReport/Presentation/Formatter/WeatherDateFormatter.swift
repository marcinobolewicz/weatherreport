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

    init(
        locale: Locale = .current,
        calendar: Calendar = .current,
        timeZone: TimeZone = .gmt
    ) {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = locale
        timeFormatter.calendar = calendar
        timeFormatter.timeZone = timeZone
        timeFormatter.dateFormat = "HH:mm'Z'"
        self.zuluTimeFormatter = timeFormatter

        let rangeFormatter = DateIntervalFormatter()
        rangeFormatter.locale = locale
        rangeFormatter.calendar = calendar
        rangeFormatter.timeZone = timeZone
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

extension TimeZone {
    static var gmt: TimeZone {
        TimeZone(secondsFromGMT: 0) ?? .current
    }
}
