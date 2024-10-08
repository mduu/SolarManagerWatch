//
//  NetworkConsumptionView.swift
//  SolarManagerWatch
//
//  Created by Marc Dürst on 05.10.2024.
//


import SwiftUI

struct NetworkConsumptionView: View {
    @Binding var currentNetworkConsumption: Double
    @Binding var maximumNetworkConsumption: Double

    var body: some View {
        VStack(spacing: 1) {
            Gauge(
                value: currentNetworkConsumption,
                in: 0...maximumNetworkConsumption
            ) {
                Text("kWh")
            } currentValueLabel: {
                Text(
                    String(
                        format: "%.1f",
                        currentNetworkConsumption)
                )
            }
            .gaugeStyle(.accessoryCircular)
            .tint(Gradient(colors: [.green, .orange, .orange, .red]))

            Image(systemName: "network")
        }
    }
}
