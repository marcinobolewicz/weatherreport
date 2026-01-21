//
//  WeatherServiceMock.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

final class MockWeatherService: WeatherService {
    enum Mode: Sendable {
        case success(WeatherReportDTO)
        case failure(Error)
        case delayedSuccess(WeatherReportDTO, nanoseconds: UInt64)
    }

    private let mode: Mode

    init(mode: Mode) {
        self.mode = mode
    }

    func fetchReport(for airportIdentifier: String) async throws -> WeatherReportDTO {
        switch mode {
        case .success(let dto):
            return dto

        case .failure(let error):
            throw error

        case .delayedSuccess(let dto, let ns):
            try? await Task.sleep(nanoseconds: ns)
            return dto
        }
    }
}
