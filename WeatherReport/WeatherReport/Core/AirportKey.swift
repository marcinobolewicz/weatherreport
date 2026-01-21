//
//  AirportKey.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 21/01/2026.
//

import Foundation

enum AirportKey {
    static func normalize(_ airport: String) -> String {
        airport.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
}
