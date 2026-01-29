//
//  HTTPMethod.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 29/01/2026.
//

enum HTTPMethod: String, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
