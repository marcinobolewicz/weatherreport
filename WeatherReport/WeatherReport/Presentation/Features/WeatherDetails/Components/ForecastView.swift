//
//  ForecastView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

struct ForecastView: View {
    let forecastViewData: ForecastViewData

    var body: some View {
        VStack(spacing: 16) {
            periodsSection

            Divider()

            rawTAFSection
        }
        .padding()
    }

    @ViewBuilder
    private var periodsSection: some View {
        if forecastViewData.periods.isEmpty {
            Text("No forecast periods available")
                .foregroundStyle(.secondary)
        } else {
            ForEach(forecastViewData.periods, id: \.id) { period in
                ForecastPeriodRow(period: period)
            }
        }
    }

    private var rawTAFSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Raw TAF")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(forecastViewData.rawTAFText.isEmpty ? "--" : forecastViewData.rawTAFText)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct ForecastPeriodRow: View {
    let period: ForecastPeriodViewData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(period.title)
                .font(.headline)
            
            HStack {
                Label(period.flightRulesText, systemImage: "airplane")
                Spacer()
                Label(period.windText, systemImage: "wind")
                Spacer()
                Label(period.visibilityText, systemImage: "eye")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview("Forecast – Sample") {
    ForecastView(
        forecastViewData: .preview
    )
}

extension ForecastViewData {
    static let preview = ForecastViewData(
        periods: [
            ForecastPeriodViewData(
                id: "1",
                title: "Afternoon",
                timeRangeText: "20 Jan 14:00–20:00 UTC",
                flightRulesText: "VFR",
                windText: "270° at 12 kt",
                visibilityText: "10 SM"
            ),
            ForecastPeriodViewData(
                id: "2",
                title: "Evening",
                timeRangeText: "20 Jan 20:00–02:00 UTC",
                flightRulesText: "MVFR",
                windText: "240° at 18 kt",
                visibilityText: "5 SM"
            ),
            ForecastPeriodViewData(
                id: "3",
                title: "Overnight",
                timeRangeText: "21 Jan 02:00–08:00 UTC",
                flightRulesText: "IFR",
                windText: "210° at 8 kt",
                visibilityText: "2 SM"
            )
        ],
        rawTAFText: """
        KPWM 201130Z 2012/2112 27012KT P6SM FEW025
          FM202000 24018KT 5SM -RA BKN020
          FM210200 21008KT 2SM BR OVC008
        """
    )
}
