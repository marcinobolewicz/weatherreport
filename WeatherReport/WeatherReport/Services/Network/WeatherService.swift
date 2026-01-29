//
//  WeatherService.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

protocol WeatherService: Sendable {
    func fetchReport(for airportIdentifier: String) async throws -> WeatherReportDTO
}

final class LiveWeatherService: WeatherService, Sendable {
    private let client: APIClienting

    init(client: APIClienting) {
        self.client = client
    }

    func fetchReport(for airportIdentifier: String) async throws -> WeatherReportDTO {
        try await client.send(ForeFlightAPI.weatherReport(airport: airportIdentifier))
    }
}

