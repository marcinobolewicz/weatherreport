//
//  ConditionsView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 19/01/2026.
//

import SwiftUI

struct ConditionsView: View {
    var conditionsViewData: ConditionsViewData
    
    var body: some View {
        VStack(spacing: 16) {
            ConditionRow(label: "Flight Rules", value: conditionsViewData.flightRulesText)
            ConditionRow(label: "Wind", value: conditionsViewData.windText)
            ConditionRow(label: "Visibility", value: conditionsViewData.visibilityText)
            ConditionRow(label: "Temperature", value: conditionsViewData.temperatureText)
            ConditionRow(label: "Dewpoint", value: conditionsViewData.dewpointText)
            ConditionRow(label: "Pressure", value: conditionsViewData.pressureText)
            ConditionRow(label: "Clouds", value: conditionsViewData.cloudsText)
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Raw METAR")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(conditionsViewData.rawMETARText.isEmpty ? "--" : conditionsViewData.rawMETARText)
                    .font(.system(.body, design: .monospaced))
                    .textSelection(.enabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}

private struct ConditionRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview("Conditions – Sample") {
    ConditionsView(
        conditionsViewData: .preview
    )
}

extension ConditionsViewData {
    static let preview = ConditionsViewData(
        title: "KPWM",
        lastUpdatedText: "Last updated: 20 Jan 2026 14:32 UTC",
        flightRulesText: "VFR",
        windText: "270° at 12 kt",
        visibilityText: "10 SM",
        temperatureText: "3°C",
        dewpointText: "-2°C",
        pressureText: "1013 hPa",
        cloudsText: "FEW 2,500 ft",
        rawMETARText: """
        KPWM 201432Z 27012KT 10SM FEW025 03/M02 A2992 RMK AO2
        """
    )
}
