//
//  Sleeper.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 20/01/2026.
//

import Foundation

protocol Sleeping: Sendable {
    func sleep(seconds: UInt64) async throws
}

struct LiveSleeper: Sleeping {
    func sleep(seconds: UInt64) async throws {
        try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
    }
}
