//
//  HTTPClientTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation
import Testing
@testable import WeatherReport

struct HTTPClientTests {
    
    @Test func fetchDecodesValidJSONSuccessfully() async throws {
        let jsonData = try TestFixtures.loadJSON(named: "data")
        let mockSession = MockURLSession(data: jsonData, statusCode: 200)
        let client = HTTPClient(session: mockSession)
        
        let result: WeatherReportDTO = try await client.fetch(
            url: URL(string: "https://example.com")!,
            headers: [:]
        )
        
        #expect(result.report.conditions.ident == "kpwm")
    }
    
    @Test func fetchThrowsDecodingFailedForInvalidJSON() async {
        let mockSession = MockURLSession(data: Data("invalid json".utf8), statusCode: 200)
        let client = HTTPClient(session: mockSession)
        
        await #expect(throws: NetworkError.decodingFailed) {
            let _: WeatherReportDTO = try await client.fetch(url: URL(string: "https://example.com")!, headers: [:])
        }
    }
    
    @Test func fetchThrowsRequestFailedForNon2xxStatus() async {
        let mockSession = MockURLSession(data: Data(), statusCode: 404)
        let client = HTTPClient(session: mockSession)
        
        await #expect(throws: NetworkError.requestFailed(statusCode: 404)) {
            let _: WeatherReportDTO = try await client.fetch(url: URL(string: "https://example.com")!, headers: [:])
        }
    }
    
    @Test func fetchThrowsNoDataForEmptyResponse() async {
        let mockSession = MockURLSession(data: Data(), statusCode: 200)
        let client = HTTPClient(session: mockSession)
        
        await #expect(throws: NetworkError.noData) {
            let _: WeatherReportDTO = try await client.fetch(url: URL(string: "https://example.com")!, headers: [:])
        }
    }
}
