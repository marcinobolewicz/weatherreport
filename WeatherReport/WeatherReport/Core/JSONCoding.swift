//
//  JSONCoding.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

protocol JSONCoding: Sendable {
    func makeDecoder() -> JSONDecoder
    func makeEncoder() -> JSONEncoder
}

struct DefaultJSONCoding: JSONCoding {
    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
