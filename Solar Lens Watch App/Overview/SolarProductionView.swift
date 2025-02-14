import SwiftUI

struct SolarProductionView: View {
    var currentSolarProduction: Int
    var maximumSolarProduction: Double
    
    var body: some View {
        VStack() {
            Gauge(
                value: Double(currentSolarProduction) / 1000,
                in: 0...Double(maximumSolarProduction) / 1000
            ) {
                Text("kW")
            } currentValueLabel: {
                Text(
                    currentSolarProduction.formatWattsAsKiloWatts()
                )
            }
            .gaugeStyle(.circular)
            .tint(getGaugeStyle())
            .accessibilityLabel("Current solar production is \(currentSolarProduction.formatWattsAsKiloWatts()) kilowatts")

            Image(systemName: "sun.max")
        }
    }
    
    private func getGaugeStyle() -> Gradient {
        if (currentSolarProduction < 50)
        {
            return Gradient(colors: [.gray, .gray])
        } else {
            return Gradient(colors: [.blue, .yellow, .orange])
        }
    }
}

#Preview("Low PV)") {
    SolarProductionView(
        currentSolarProduction: 1000,
        maximumSolarProduction: 11000)
}

#Preview("Max PV)") {
    SolarProductionView(
        currentSolarProduction: 11000,
        maximumSolarProduction: 11000)
}


#Preview("Ver-low PV)") {
    SolarProductionView(
        currentSolarProduction: 45,
        maximumSolarProduction: 11000)
}

#Preview("No PV)") {
    SolarProductionView(
        currentSolarProduction: 0,
        maximumSolarProduction: 11000)
}
