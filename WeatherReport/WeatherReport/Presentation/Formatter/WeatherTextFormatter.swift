//
//  WeatherTextFormatter.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

struct WeatherTextFormatter: Sendable {
    let dateFormatter: WeatherDateFormatting
    let numberFormatter: WeatherNumberFormatting

    init(
        dateFormatter: WeatherDateFormatting = WeatherDateFormatter(),
        numberFormatter: WeatherNumberFormatting = WeatherNumberFormatter()
    ) {
        self.dateFormatter = dateFormatter
        self.numberFormatter = numberFormatter
    }

    func makeConditionsViewData(from model: ConditionsModel) async -> ConditionsViewData {
        let lastUpdated = await dateFormatter.formatZuluTime(model.issuedAt)
        return ConditionsViewData(
            title: model.title,
            lastUpdatedText: "Last updated: \(lastUpdated))",
            flightRulesText: model.flightRules.uppercased(),
            windText: windText(model.wind),
            visibilityText: visibilityText(model.visibility),
            temperatureText: "\(numberFormatter.formatOneDecimal(model.temperatureC))°C",
            dewpointText: "\(numberFormatter.formatOneDecimal(model.dewpointC))°C",
            pressureText: "\(numberFormatter.formatOneDecimal(model.pressureHpa)) hPa",
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
                timeRangeText = await dateFormatter.formatZuluRange(period.start, period.end)
            } else {
                timeRangeText = ""
            }
            
            periods.append(
                ForecastPeriodViewData(
                    id: "\(index)",
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
    
    func makeReportDateString(from date: Date) async -> String {
        await dateFormatter.formatZuluTime(date)
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
        let formattedValue = numberFormatter.formatOneDecimal(visibility.distanceSm)
        if visibility.qualifier == 1 { return "P\(formattedValue) SM" }
        return "\(formattedValue) SM"
    }

    private func cloudsText(_ layers: [CloudLayerModel]) -> String {
        guard !layers.isEmpty else { return "--" }
        return layers
            .map { "\($0.coverage.uppercased()) \(Int($0.altitudeFt))" }
            .joined(separator: " • ")
    }
}

