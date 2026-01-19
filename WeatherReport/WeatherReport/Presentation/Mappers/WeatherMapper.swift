//
//  WeatherMapper.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

struct WeatherMapper: Sendable {
    func mapConditions(from dto: WeatherReportDTO) -> ConditionsModel {
        let conditions = dto.report.conditions
        return ConditionsModel(
            title: conditions.ident.uppercased(),
            issuedAt: conditions.dateIssued,
            flightRules: conditions.flightRules,
            wind: WindModel(
                directionDegrees: conditions.wind.direction,
                speedKts: conditions.wind.speedKts,
                gustKts: conditions.wind.gustSpeedKts
            ),
            visibility: VisibilityModel(
                distanceSm: conditions.visibility.distanceSm,
                qualifier: conditions.visibility.distanceQualifier
            ),
            temperatureC: conditions.tempC,
            dewpointC: conditions.dewpointC,
            pressureHpa: conditions.pressureHpa,
            cloudLayers: conditions.cloudLayers.map { .init(coverage: $0.coverage, altitudeFt: $0.altitudeFt) },
            rawMETAR: conditions.text
        )
    }
    
    func mapForecast(from dto: WeatherReportDTO, maxPeriods: Int = 7) -> ForecastModel {
        let forecast = dto.report.forecast
        let periods = forecast.conditions.prefix(maxPeriods).map { item in
            ForecastPeriodModel(
                period: item.period.map { .init(start: $0.dateStart, end: $0.dateEnd) },
                flightRules: item.flightRules,
                wind: WindModel(
                    directionDegrees: item.wind.direction,
                    speedKts: item.wind.speedKts,
                    gustKts: item.wind.gustSpeedKts
                ),
                visibility: VisibilityModel(
                    distanceSm: item.visibility.distanceSm,
                    qualifier: item.visibility.distanceQualifier
                )
            )
        }
        return ForecastModel(periods: periods, rawTAF: forecast.text)
    }
}
