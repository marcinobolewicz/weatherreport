//
//  ReportResult.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

struct ReportResult: Sendable {
    let dto: WeatherReportDTO
    let source: Source

    enum Source: Sendable {
        case live
        case cache
    }
}
