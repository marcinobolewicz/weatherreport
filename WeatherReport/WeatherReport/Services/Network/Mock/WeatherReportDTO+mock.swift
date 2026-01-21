//
//  WeatherReportDTO+mock.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import Foundation

extension WeatherReportDTO {
    static func mockKPWM() -> WeatherReportDTO {
        let issued = Date(timeIntervalSince1970: 1_736_000_000)

        return WeatherReportDTO(
            report: ReportDTO(
                conditions: ConditionsDTO(
                    text: "KPWM 161651Z 26012G18KT 10SM FEW020 SCT050 02/M03 A2992 RMK AO2",
                    ident: "KPWM",
                    dateIssued: issued,
                    flightRules: "VFR", tempC: 2.0,
                    dewpointC: -3.0,
                    pressureHpa: 1013.2,

                    cloudLayers: [
                        CloudLayerDTO(coverage: "few", altitudeFt: 2000, ceiling: false, altitudeQualifier: nil),
                        CloudLayerDTO(coverage: "sct", altitudeFt: 5000, ceiling: false, altitudeQualifier: nil)
                    ],

                    weather: ["-SN", "BR"],

                    visibility: VisibilityDTO(
                        distanceSm: 10.0,
                        distanceMeter: nil,
                        distanceQualifier: nil,
                        prevailingVisSm: nil,
                        prevailingVisMeter: nil,
                        prevailingVisDistanceQualifier: nil,
                        visReportedInMetric: nil
                    ),

                    wind: WindDTO(
                        direction: 260,
                        speedKts: 12.0,
                        gustSpeedKts: 18.0
                    )
                ),

                forecast: ForecastDTO(
                    text: """
                    KPWM 161740Z 1618/1718 25012G20KT P6SM SCT040
                      FM170000 24010KT P6SM BKN050
                      FM170600 23008KT 4SM -SN OVC020
                      FM171200 21010KT P6SM SCT030
                    """,
                    ident: "KPWM",
                    dateIssued: issued,
                    period: PeriodDTO(
                        dateStart: issued.addingTimeInterval(60 * 60),       // +1h
                        dateEnd: issued.addingTimeInterval(60 * 60 * 24)     // +24h
                    ),

                    lat: 43.6462,
                    lon: -70.3093,
                    elevationFt: 76,

                    conditions: [
                        ForecastConditionDTO(
                            text: "1618/1700 25012G20KT P6SM SCT040",
                            dateIssued: issued,
                            flightRules: "VFR",
                            weather: [],
                            visibility: VisibilityDTO(
                                distanceSm: 6.0,
                                distanceMeter: nil,
                                distanceQualifier: 1, // "P6SM" vibe
                                prevailingVisSm: nil,
                                prevailingVisMeter: nil,
                                prevailingVisDistanceQualifier: nil,
                                visReportedInMetric: nil
                            ),
                            wind: WindDTO(
                                direction: 250,
                                speedKts: 12.0,
                                gustSpeedKts: 20.0
                            ),
                            period: PeriodDTO(
                                dateStart: issued.addingTimeInterval(60 * 60 * 2), // +2h
                                dateEnd: issued.addingTimeInterval(60 * 60 * 6)    // +6h
                            )
                        ),
                        ForecastConditionDTO(
                            text: "FM170000 24010KT P6SM BKN050",
                            dateIssued: issued,
                            flightRules: "VFR",
                            weather: [],
                            visibility: VisibilityDTO(
                                distanceSm: 6.0,
                                distanceMeter: nil,
                                distanceQualifier: 1,
                                prevailingVisSm: nil,
                                prevailingVisMeter: nil,
                                prevailingVisDistanceQualifier: nil,
                                visReportedInMetric: nil
                            ),
                            wind: WindDTO(
                                direction: 240,
                                speedKts: 10.0,
                                gustSpeedKts: nil
                            ),
                            period: PeriodDTO(
                                dateStart: issued.addingTimeInterval(60 * 60 * 8),
                                dateEnd: issued.addingTimeInterval(60 * 60 * 12)
                            )
                        ),
                        ForecastConditionDTO(
                            text: "FM170600 23008KT 4SM -SN OVC020",
                            dateIssued: issued,
                            flightRules: "IFR",
                            weather: ["-SN"],
                            visibility: VisibilityDTO(
                                distanceSm: 4.0,
                                distanceMeter: nil,
                                distanceQualifier: nil,
                                prevailingVisSm: nil,
                                prevailingVisMeter: nil,
                                prevailingVisDistanceQualifier: nil,
                                visReportedInMetric: nil
                            ),
                            wind: WindDTO(
                                direction: 230,
                                speedKts: 8.0,
                                gustSpeedKts: nil
                            ),
                            period: PeriodDTO(
                                dateStart: issued.addingTimeInterval(60 * 60 * 14),
                                dateEnd: issued.addingTimeInterval(60 * 60 * 18)
                            )
                        )
                    ]
                )
            )
        )
    }
}
