//
//  ForecastModel.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct ForecastModel: Equatable, Sendable {
    let periods: [ForecastPeriodModel]
    let rawTAF: String
}

struct ForecastPeriodModel: Equatable, Sendable {
    let period: PeriodModel?
    let flightRules: String
    let wind: WindModel
    let visibility: VisibilityModel
}

struct PeriodModel: Equatable, Sendable {
    let start: Date
    let end: Date
}
