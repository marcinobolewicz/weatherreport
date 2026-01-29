//
//  APIClient.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 29/01/2026.
//

import Foundation

protocol APIClienting: Sendable {
    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint<Response>) async throws -> Response
}

final class APIClient: APIClienting, Sendable {
    private let baseURL: URL
    private let httpClient: HTTPClient

    init(baseURL: URL, httpClient: HTTPClient) {
        self.baseURL = baseURL
        self.httpClient = httpClient
    }

    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint<Response>) async throws -> Response {
        try await httpClient.send(endpoint, baseURL: baseURL)
    }
}
