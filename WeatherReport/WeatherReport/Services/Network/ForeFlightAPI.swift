//
//  ForeFlightAPI.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 29/01/2026.
//

import Foundation

enum ForeFlightAPI {
    static func weatherReport(airport: String) -> Endpoint<WeatherReportDTO> {
        let key = AirportKey.normalize(airport)
        return Endpoint(
            method: .get,
            path: "/weather/report/\(key)",
            headers: ["ff-coding-exercise": "1"]
        )
    }
}
