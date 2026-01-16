//
//  WeatherService.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

protocol WeatherServiceProtocol: Sendable {
    func fetchWeatherReport(for airportIdentifier: String) async throws -> WeatherReportDTO
}

final class WeatherService: WeatherServiceProtocol, Sendable {
    
    private let httpClient: HTTPClientProtocol
    private let baseURL: String
    
    private enum Constants {
        static let baseURL = "https://qa.foreflight.com/weather/report"
        static let headerKey = "ff-coding-exercise"
    }
    
    init(httpClient: HTTPClientProtocol, baseURL: String = Constants.baseURL) {
        self.httpClient = httpClient
        self.baseURL = baseURL
    }
    
    func fetchWeatherReport(for airportIdentifier: String) async throws -> WeatherReportDTO {
        let identifier = airportIdentifier.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !identifier.isEmpty else {
            throw NetworkError.invalidURL
        }
        
        guard let url = URL(string: "\(baseURL)/\(identifier)") else {
            throw NetworkError.invalidURL
        }
        
        return try await httpClient.fetch(url: url, headers: [Constants.headerKey: "1"])
    }
}
