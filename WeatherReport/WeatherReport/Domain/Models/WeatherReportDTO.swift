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
    let forecast: ForecastDTO
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
// MARK: - Forecast (TAF)

struct ForecastDTO: Decodable, Equatable, Sendable {
    let text: String           // raw TAF
    let ident: String
    let dateIssued: Date
    let period: PeriodDTO?

    let lat: Double?
    let lon: Double?
    let elevationFt: Double?

    let conditions: [ForecastConditionDTO]
}

struct ForecastConditionDTO: Decodable, Equatable, Sendable {
    let text: String
    let dateIssued: Date?

    let flightRules: String

    let weather: [String]
    let visibility: VisibilityDTO
    let wind: WindDTO

    let period: PeriodDTO?
}

// MARK: - Shared primitives

struct PeriodDTO: Decodable, Equatable, Sendable {
    let dateStart: Date
    let dateEnd: Date
}
struct VisibilityDTO: Decodable, Equatable, Sendable {
    let distanceSm: Double
    let distanceMeter: Double?
    let distanceQualifier: Int?

    let prevailingVisSm: Double?
    let prevailingVisMeter: Double?
    let prevailingVisDistanceQualifier: Int?

    let visReportedInMetric: Bool?
}

struct WindDTO: Decodable, Equatable, Sendable {
    let direction: Int
    let speedKts: Double
    let gustSpeedKts: Double?
}

struct CloudLayerDTO: Decodable, Equatable, Sendable {
    let coverage: String
    let altitudeFt: Double
    let ceiling: Bool

    let altitudeQualifier: Int?
}
