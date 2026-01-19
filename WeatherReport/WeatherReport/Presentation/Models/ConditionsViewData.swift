//
//  ConditionsViewData.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct ConditionsViewData: Equatable, Sendable {
    let title: String
    let lastUpdatedText: String

    let flightRulesText: String
    let windText: String
    let visibilityText: String
    let temperatureText: String
    let dewpointText: String
    let pressureText: String
    let cloudsText: String

    let rawMETARText: String
}
