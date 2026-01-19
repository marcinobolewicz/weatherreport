//
//  ConditionsModel.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct ConditionsModel: Equatable, Sendable {
    let title: String
    let issuedAt: Date
    let flightRules: String        
    let wind: WindModel
    let visibility: VisibilityModel
    let temperatureC: Double
    let dewpointC: Double
    let pressureHpa: Double
    let cloudLayers: [CloudLayerModel]
    let rawMETAR: String
}

struct WindModel: Equatable, Sendable {
    let directionDegrees: Int
    let speedKts: Double
    let gustKts: Double?
}

struct VisibilityModel: Equatable, Sendable {
    let distanceSm: Double
    let qualifier: Int?
}

struct CloudLayerModel: Equatable, Sendable {
    let coverage: String
    let altitudeFt: Double
}
