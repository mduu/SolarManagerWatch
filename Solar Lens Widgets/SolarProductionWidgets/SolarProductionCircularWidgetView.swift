//
//  SolarProductionCircularWidget.swift
//  Solar Lens Watch App
//
//  Created by Marc Dürst on 23.11.2024.
//

import SwiftUI
import WidgetKit

struct SolarProductionCircularWidgetView: View {
    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.showsWidgetLabel) private var showsWidgetLabel

    var currentProduction: Int?
    var maxProduction: Double?

    var body: some View {
        let current = Double(currentProduction ?? 0) / 1000
        let max = Double(maxProduction ?? 0) / 1000

        ZStack {
            AccessoryWidgetBackground()

            if showsWidgetLabel {
            
                ZStack {
                    AccessoryWidgetBackground()
                    if renderingMode == .fullColor {
                        Image("solarlens")
                    } else {
                        Image("solarlenstrans")
                    }
                }
                .widgetLabel {
                    Text("☀️ \(String(format: "%.1f kW", current))")
                }
                
            } else {
                
                Gauge(
                    value: current,
                    in: 0...max
                ) {
                    Image(systemName: "sun.max")
                } currentValueLabel: {
                    Text("\(String(format: "%.1f", current))")
                }
                .gaugeStyle(.circular)
                .tint(renderingMode == .fullColor ? getGaugeStyle() : nil)
            
            }
        }
    }

    func getGaugeStyle() -> Gradient {
        return currentProduction ?? 0 < 50
            ? Gradient(colors: [.gray, .gray])
            : Gradient(colors: [.blue, .yellow, .orange])
    }
}

#Preview("Zero") {
    SolarProductionCircularWidgetView()
}

#Preview("4kW") {
    SolarProductionCircularWidgetView(
        currentProduction: 4000,
        maxProduction: 11000
    )
}

#Preview("accented") {
    SolarProductionCircularWidgetView(
        currentProduction: 4000,
        maxProduction: 11000
    ).environment(\.widgetRenderingMode, .accented)
}

#Preview("vibrant") {
    SolarProductionCircularWidgetView(
        currentProduction: 4000,
        maxProduction: 11000
    ).environment(\.widgetRenderingMode, .vibrant)
}
