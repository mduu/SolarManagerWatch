import AppIntents

struct GetBatteryLevelIntent: AppIntent {
    static var title: LocalizedStringResource = "Get current battery level"
    static var description: IntentDescription? =
        "Get the current battery level in percent"

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int>
        & ProvidesDialog
    {
        let solarManager = SolarManager.instance()
        let solarProduction = try? await solarManager.fetchOverviewData(
            lastOverviewData: nil)

        guard let batteryLevel = solarProduction?.currentBatteryLevel else {
            throw IntentError.couldNotGetValue(
                "Could not retrieve battery level")
        }

        let dialog = IntentDialog(
            full: "The battery level of our house is at \(batteryLevel)%",
            supporting:
                "I found this information in Solar Manager using Solar Lens",
            systemImageName: "battery.100percent"
        )

        return .result(value: batteryLevel, dialog: dialog)
    }
}
