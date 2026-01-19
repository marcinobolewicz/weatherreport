//
//  ForecastViewData.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct ForecastViewData: Equatable, Sendable {
    let periods: [ForecastPeriodViewData] 
    let rawTAFText: String
}

struct ForecastPeriodViewData: Equatable, Sendable, Identifiable {
    let id: String

    let title: String
    let timeRangeText: String

    let flightRulesText: String
    let windText: String
    let visibilityText: String
}
