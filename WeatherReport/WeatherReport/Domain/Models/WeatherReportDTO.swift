//
//  WeatherReportDTO.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

struct WeatherReportDTO: Decodable, Equatable, Sendable {
    let report: ReportDTO
}

struct ReportDTO: Decodable, Equatable, Sendable {
    let conditions: ConditionsDTO
}

/// METAR weather conditions
struct ConditionsDTO: Decodable, Equatable, Sendable {
    /// Raw METAR text
    let text: String
    let ident: String
    let dateIssued: Date
    /// Flight category: VFR/MVFR/IFR/LIFR
    let flightRules: String
    let tempC: Double
    let dewpointC: Double
    let pressureHpa: Double
    let cloudLayers: [CloudLayerDTO]
    /// Weather phenomena (may be empty)
    let weather: [String]
    let visibility: VisibilityDTO
    let wind: WindDTO
}

struct VisibilityDTO: Decodable, Equatable, Sendable {
    /// Visibility in statute miles
    let distanceSm: Double
}

struct WindDTO: Decodable, Equatable, Sendable {
    let direction: Int
    let speedKts: Double
    let gustSpeedKts: Double?
}

struct CloudLayerDTO: Decodable, Equatable, Sendable {
    /// Coverage: few/sct/bkn/ovc
    let coverage: String
    let altitudeFt: Double
    let ceiling: Bool
}
