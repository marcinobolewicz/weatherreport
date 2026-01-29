//
//  TestDoubles.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation
@testable import WeatherReport

// MARK: - Mock URL Session

final class MockURLSession: NetworkSessioning, @unchecked Sendable {
    private let mockData: Data
    private let mockStatusCode: Int
    
    init(data: Data, statusCode: Int) {
        self.mockData = data
        self.mockStatusCode = statusCode
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: mockStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (mockData, response)
    }
}

// MARK: - Mock UserDefaults

extension UserDefaults {
    /// Creates an isolated UserDefaults instance for testing
    static func makeMock() -> UserDefaults {
        let suiteName = "test_\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
