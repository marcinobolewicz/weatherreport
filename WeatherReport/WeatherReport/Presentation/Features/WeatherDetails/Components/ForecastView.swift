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
