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
    
    private let httpClient: HTTPClient
    private let baseURL: String
    
    private enum Constants {
        static let baseURL = "https://qa.foreflight.com/weather/report"
        static let headerKey = "ff-coding-exercise"
    }
    
    init(httpClient: HTTPClient, baseURL: String = Constants.baseURL) {
        self.httpClient = httpClient
        self.baseURL = baseURL
    }
    
    func fetchReport(for airportIdentifier: String) async throws -> WeatherReportDTO {
        let identifier = AirportKey.normalize(airportIdentifier)
        
        guard !identifier.isEmpty else {
            throw NetworkError.invalidURL
        }
        
        guard let url = URL(string: "\(baseURL)/\(identifier)") else {
            throw NetworkError.invalidURL
        }
        
        return try await httpClient.fetch(url: url, headers: [Constants.headerKey: "1"])
    }
}
