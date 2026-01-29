//
//  Endpoint.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 29/01/2026.
//

import Foundation

struct Endpoint<Response: Decodable & Sendable>: Sendable {
    let method: HTTPMethod
    let path: String
    let query: [URLQueryItem]
    let headers: [String: String]
    let body: Data?

    init(
        method: HTTPMethod = .get,
        path: String,
        query: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.method = method
        self.path = path
        self.query = query
        self.headers = headers
        self.body = body
    }
}
