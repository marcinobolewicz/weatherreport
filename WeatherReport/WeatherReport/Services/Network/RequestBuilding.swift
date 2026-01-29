//
//  RequestBuilding.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 29/01/2026.
//

import Foundation

protocol RequestBuilding: Sendable {
    func makeRequest<Response: Decodable & Sendable>(
        baseURL: URL,
        endpoint: Endpoint<Response>
    ) throws -> URLRequest
}

struct DefaultRequestBuilder: RequestBuilding {
    func makeRequest<Response: Decodable & Sendable>(
        baseURL: URL,
        endpoint: Endpoint<Response>
    ) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        let extraPath = endpoint.path.hasPrefix("/") ? endpoint.path : "/" + endpoint.path
        components.path = components.path + extraPath
        if !endpoint.query.isEmpty { components.queryItems = endpoint.query }

        guard let url = components.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return request
    }
}

