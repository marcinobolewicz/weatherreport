//
//  WeatherServiceTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation
import Testing
@testable import WeatherReport

struct WeatherServiceTests {
    
    @Test func fetchReturnsWeatherReportOnSuccess() async throws {
        let mockClient = MockHTTPClient()
        let expectedDTO = try TestFixtures.loadWeatherReportDTO()
        mockClient.resultToReturn = expectedDTO
        let service = WeatherService(httpClient: mockClient)
        
        let result = try await service.fetchWeatherReport(for: "kpwm")
        
        #expect(result == expectedDTO)
    }
    
    @Test func fetchWithEmptyIdentifierThrowsInvalidURL() async {
        let service = makeService()
        
        await #expect(throws: NetworkError.invalidURL) {
            try await service.fetchWeatherReport(for: "")
        }
    }
    
    @Test func fetchWithWhitespaceOnlyThrowsInvalidURL() async {
        let service = makeService()
        
        await #expect(throws: NetworkError.invalidURL) {
            try await service.fetchWeatherReport(for: "   ")
        }
    }
    
    @Test func fetchNormalizesIdentifierToLowercase() async throws {
        let mockClient = MockHTTPClient()
        let service = WeatherService(httpClient: mockClient)
        
        _ = try? await service.fetchWeatherReport(for: "KPWM")
        
        #expect(mockClient.lastRequestedURL?.absoluteString.contains("kpwm") == true)
    }
    
    @Test func fetchTrimsWhitespace() async throws {
        let mockClient = MockHTTPClient()
        let service = WeatherService(httpClient: mockClient)
        
        _ = try? await service.fetchWeatherReport(for: "  kpwm  ")
        
        let urlString = mockClient.lastRequestedURL?.absoluteString ?? ""
        #expect(urlString.hasSuffix("kpwm"))
    }
    
    @Test func fetchIncludesRequiredHeader() async throws {
        let mockClient = MockHTTPClient()
        let service = WeatherService(httpClient: mockClient)
        
        _ = try? await service.fetchWeatherReport(for: "kpwm")
        
        #expect(mockClient.lastRequestedHeaders?["ff-coding-exercise"] == "1")
    }
    
    // MARK: - Helpers
    
    private func makeService() -> WeatherService {
        WeatherService(httpClient: MockHTTPClient())
    }
}
