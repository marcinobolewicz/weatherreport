//
//  WeatherDetailsView.swift
//  WeatherReport
//
//  Created by Marcin Obolewicz on 16/01/2026.
//

import SwiftUI

struct WeatherDetailsView: View {
    
    let airportIdentifier: String
    
    @State private var selectedTab: DetailTab = .conditions
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            // Tab Picker
            Picker("", selection: $selectedTab) {
                ForEach(DetailTab.allCases, id: \.self) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Content
            ScrollView {
                switch selectedTab {
                case .conditions:
                    ConditionsView()
                case .forecast:
                    ForecastView()
                }
            }
            .refreshable {
                // TODO: Implement pull-to-refresh
                try? await Task.sleep(for: .seconds(1))
            }
        }
        .navigationTitle(airportIdentifier)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: Manual refresh
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    private var header: some View {
        VStack(spacing: 4) {
            Text(airportIdentifier)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Last updated: --")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Detail Tab

enum DetailTab: CaseIterable {
    case conditions
    case forecast
    
    var title: String {
        switch self {
        case .conditions: return "Conditions"
        case .forecast: return "Forecast"
        }
    }
}

// MARK: - Conditions View (Placeholder)

private struct ConditionsView: View {
    var body: some View {
        VStack(spacing: 16) {
            ConditionRow(label: "Flight Rules", value: "--")
            ConditionRow(label: "Wind", value: "--")
            ConditionRow(label: "Visibility", value: "--")
            ConditionRow(label: "Temperature", value: "--")
            ConditionRow(label: "Dewpoint", value: "--")
            ConditionRow(label: "Pressure", value: "--")
            ConditionRow(label: "Clouds", value: "--")
            
            Divider()
            
            // Raw METAR
            VStack(alignment: .leading, spacing: 8) {
                Text("Raw METAR")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("--")
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

// MARK: - Forecast View (Placeholder)

private struct ForecastView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Forecast data will appear here")
                .foregroundStyle(.secondary)
            
            // Placeholder forecast periods
            ForEach(0..<3, id: \.self) { index in
                ForecastPeriodRow(
                    period: "Period \(index + 1)",
                    flightRules: "--",
                    wind: "--",
                    visibility: "--"
                )
            }
            
            Divider()
            
            // Raw TAF
            VStack(alignment: .leading, spacing: 8) {
                Text("Raw TAF")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("--")
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

private struct ForecastPeriodRow: View {
    let period: String
    let flightRules: String
    let wind: String
    let visibility: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(period)
                .font(.headline)
            
            HStack {
                Label(flightRules, systemImage: "airplane")
                Spacer()
                Label(wind, systemImage: "wind")
                Spacer()
                Label(visibility, systemImage: "eye")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack {
        WeatherDetailsView(airportIdentifier: "KPWM")
    }
}
