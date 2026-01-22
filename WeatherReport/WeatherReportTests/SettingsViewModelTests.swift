//
//  SettingsViewModelTests.swift
//  WeatherReportTests
//
//  Created by Marcin Obolewicz on 22/01/2026.
//

import Testing
import Foundation
@testable import WeatherReport

@Suite("SettingsViewModel Tests")
@MainActor
struct SettingsViewModelTests {
    
    private struct FailingWeatherRepository: WeatherRepository {
        func observeOnAppear(airport: String) -> AsyncThrowingStream<ReportEvent, Error> {
            AsyncThrowingStream { $0.finish() }
        }
        func refresh(airport: String) async throws -> WeatherReportDTO {
            throw NetworkError.noData
        }
        func clearCache() async throws {
            throw NetworkError.noData
        }
        func refresh(airport: String) async throws -> WeatherReport.ReportResult {
            ReportResult(dto: .mockKPWM(), source: .live)
        }
    }
    
    @Test("clearCache sets error flags on failure")
    func clearCacheSetsErrorOnFailure() async {
        let vm = SettingsViewModel(
            appSettings: MockAppSettings(),
            weatherRepository: FailingWeatherRepository()
        )
        
        await vm.clearCache()
        
        #expect(vm.isErrorPresented == true)
        #expect(vm.errorMessage != nil)
        #expect(vm.isClearingCache == false)
    }
}
