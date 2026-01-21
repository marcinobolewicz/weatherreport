//
//  HTTPClient.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

protocol NetworkSessioning: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkSessioning {}

protocol HTTPClient: Sendable {
    func fetch<T: Decodable>(url: URL, headers: [String: String]) async throws -> T
}

final class DefaultHTTPClient: HTTPClient, Sendable {
    private let session: NetworkSessioning
    private let coding: JSONCoding
    
    init(
        session: NetworkSessioning = URLSession.shared,
        coding: JSONCoding = DefaultJSONCoding()
    ) {
        self.session = session
        self.coding = coding
    }
    
    func fetch<T: Decodable>(url: URL, headers: [String: String] = [:]) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown("Invalid response type")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            return try coding.makeDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
