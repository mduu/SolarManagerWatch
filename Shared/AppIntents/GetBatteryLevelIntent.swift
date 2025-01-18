import AppIntents

struct GetBatteryLevelIntent: AppIntent {
    static var title: LocalizedStringResource = "Get current battery level"
    static var description: IntentDescription? =
        "Get the current battery level in percent"

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        let enegeryManager = SolarManager()
        let solarProduction = try? await enegeryManager.fetchOverviewData(
            lastOverviewData: nil)

        guard let batteryLevel = solarProduction?.currentBatteryLevel else {
            throw IntentError.couldNotGetValue(
                "Could not retrieve battery level")
        }

        return .result(value: batteryLevel)
    }
}
