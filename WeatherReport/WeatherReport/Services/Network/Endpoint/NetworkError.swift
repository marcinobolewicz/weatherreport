//
//  NetworkError.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case requestFailed(statusCode: Int)
    case noData
    case decodingFailed
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let statusCode):
            return "Request failed with status code: \(statusCode)"
        case .noData:
            return "No data received"
        case .decodingFailed:
            return "Failed to decode response"
        case .unknown(let message):
            return message
        }
    }
}
