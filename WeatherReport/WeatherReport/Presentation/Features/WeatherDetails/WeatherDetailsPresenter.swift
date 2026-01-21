//
//  WeatherDetailsPresenter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

protocol WeatherDetailsPresenting: Sendable {
    func makeConditions(from dto: WeatherReportDTO) async -> ConditionsViewData
    func makeForecast(from dto: WeatherReportDTO) async -> ForecastViewData
    func makeReportDateString(from date: Date) async -> String
}

struct WeatherDetailsPresenter: WeatherDetailsPresenting {
    private let mapper: WeatherMapper
    private let formatter: WeatherTextFormatter

    init(
        mapper: WeatherMapper = WeatherMapper(),
        formatter: WeatherTextFormatter = WeatherTextFormatter()
    ) {
        self.mapper = mapper
        self.formatter = formatter
    }

    func makeConditions(from dto: WeatherReportDTO) async -> ConditionsViewData {
        let model = mapper.mapConditions(from: dto)
        return await formatter.makeConditionsViewData(from: model)
    }

    func makeForecast(from dto: WeatherReportDTO) async -> ForecastViewData {
        let model = mapper.mapForecast(from: dto)
        return await formatter.makeForecastViewData(from: model)
    }
    
    func makeReportDateString(from date: Date) async -> String {
        await formatter.makeReportDateString(from: date)
    }
}
