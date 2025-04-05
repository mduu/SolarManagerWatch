extension Int {

    func formatWattsAsKiloWatts(widthUnit: Bool = false) -> String {
        String(
            format: widthUnit ? "%.1f \(getUnitKw())" : "%.1f",
            Double(self) / 1000)
    }

    func formatAsKiloWatts(widthUnit: Bool = false) -> String {
        widthUnit
            ? "\(String(format: "%.1f", self)) \(getUnitKw())"
            : String(format: "%.1f", self)
    }
    
    private func getUnitKw() -> String {
        "kW"
    }
}

extension Int? {
    func formatIntoPercentage() -> String {
        String(
            format: "%.0f%%",
            Double(self ?? 0))
    }

    func formatWattsAsKiloWatts(widthUnit: Bool = false) -> String {
        self == nil
            ? "-"
            : String(
                format: widthUnit ? "%.1f kW" : "%.1f",
                Double(self!) / 1000)
    }
}
