//
//  WeatherTextFormatter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct WeatherTextFormatter: Sendable {
    let date: WeatherDateFormatting
    let number: WeatherNumberFormatting

    init(
        date: WeatherDateFormatting = WeatherDateFormatter(),
        number: WeatherNumberFormatting = WeatherNumberFormatter()
    ) {
        self.date = date
        self.number = number
    }

    func makeConditionsViewData(from model: ConditionsModel) async -> ConditionsViewData {
        let lastUpdated = await date.formatZuluTime(model.issuedAt)
        return ConditionsViewData(
            title: model.title,
            lastUpdatedText: "Last updated: \(lastUpdated))",
            flightRulesText: model.flightRules.uppercased(),
            windText: windText(model.wind),
            visibilityText: visibilityText(model.visibility),
            temperatureText: "\(number.formatOneDecimal(model.temperatureC))°C",
            dewpointText: "\(number.formatOneDecimal(model.dewpointC))°C",
            pressureText: "\(number.formatOneDecimal(model.pressureHpa)) hPa",
            cloudsText: cloudsText(model.cloudLayers),
            rawMETARText: model.rawMETAR
        )
    }

    func makeForecastViewData(from model: ForecastModel) async -> ForecastViewData {
        var periods: [ForecastPeriodViewData] = []
        periods.reserveCapacity(model.periods.count)
        
        for (index, periodModel) in model.periods.enumerated() {
            let timeRangeText: String
            if let period = periodModel.period {
                timeRangeText = await date.formatZuluRange(period.start, period.end)
            } else {
                timeRangeText = ""
            }
            
            periods.append(
                ForecastPeriodViewData(
                    id: periodID(periodModel.period),
                    title: "Period \(index + 1)",
                    timeRangeText: timeRangeText,
                    flightRulesText: periodModel.flightRules.uppercased(),
                    windText: windText(periodModel.wind),
                    visibilityText: visibilityText(periodModel.visibility)
                )
            )
        }
        
        return ForecastViewData(periods: periods, rawTAFText: model.rawTAF)
    }

    // MARK: - helpers

    private func windText(_ wind: WindModel) -> String {
        let roundedSpeed = Int(wind.speedKts.rounded())
        if let gust = wind.gustKts {
            return "\(wind.directionDegrees)° \(roundedSpeed)G\(Int(gust.rounded())) kt"
        }
        return "\(wind.directionDegrees)° \(roundedSpeed) kt"
    }

    private func visibilityText(_ visibility: VisibilityModel) -> String {
        let formattedValue = number.formatOneDecimal(visibility.distanceSm)
        if visibility.qualifier == 1 { return "P\(formattedValue) SM" }
        return "\(formattedValue) SM"
    }

    private func cloudsText(_ layers: [CloudLayerModel]) -> String {
        guard !layers.isEmpty else { return "--" }
        return layers
            .map { "\($0.coverage.uppercased()) \(Int($0.altitudeFt))" }
            .joined(separator: " • ")
    }

    private func periodID(_ period: PeriodModel?) -> String {
        guard let p = period else { return UUID().uuidString }
        return "\(p.start.timeIntervalSince1970)-\(p.end.timeIntervalSince1970)"
    }
}

