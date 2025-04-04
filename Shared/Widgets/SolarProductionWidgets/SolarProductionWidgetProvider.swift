import Foundation
import WidgetKit

struct SolarProductionWidgetProvider: AppIntentTimelineProvider {
    let widgetDataSource = SolarLensWidgetDataSource()

    func placeholder(in context: Context) -> SolarProductionEntry {
        return .previewData()
    }

    func snapshot(
        for configuration: SolarProductionAppIntent, in context: Context
    ) async -> SolarProductionEntry {

        if context.isPreview {
            // A complication with generic data for preview
            return .previewData()
        }

        let data = try? await widgetDataSource.getOverviewData()
        let solarData = try? await widgetDataSource.getSolarProductionData()
        
        print("SolarProduction Snapshot-Data \(String(describing: data))")

        return SolarProductionEntry(
            date: Date(),
            currentProduction: data?.currentSolarProduction,
            maxProduction: data?.solarProductionMax,
            todaySolarProduction: solarData?.todaySolarProduction,
            forecastToday: solarData?.forecastToday,
            forecastTomorrow: solarData?.forecastTomorrow,
            forecastDayAfterTomorrow: solarData?.forecastDayAfterTomorrow
        )
    }

    func timeline(
        for configuration: SolarProductionAppIntent, in context: Context
    ) async -> Timeline<SolarProductionEntry> {
        var entries: [SolarProductionEntry] = []

        if context.isPreview {
            // A complication with generic data for preview
            entries.append(.previewData())
        } else {
            let data = try? await widgetDataSource.getOverviewData()
            let solarData = try? await widgetDataSource.getSolarProductionData()

            print("SolarProduction Timeline-Data \(String(describing: data))")

            entries.append(
                SolarProductionEntry(
                    date: Date(),
                    currentProduction: data?.currentSolarProduction,
                    maxProduction: data?.solarProductionMax,
                    todaySolarProduction: solarData?.todaySolarProduction,
                    forecastToday: solarData?.forecastToday,
                    forecastTomorrow: solarData?.forecastTomorrow,
                    forecastDayAfterTomorrow: solarData?.forecastDayAfterTomorrow
                )
            )
        }
        
        // Update every 5 minutes
        let currentDate = Date()
        let fiveMinutesLater = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        return Timeline(
            entries: entries,
            policy: .after(fiveMinutesLater))
    }

    func recommendations() -> [AppIntentRecommendation<
        SolarProductionAppIntent
    >] {
        // Create an array with all the preconfigured widgets to show.
        [
            AppIntentRecommendation(
                intent: SolarProductionAppIntent(),
                description: "Current Solar Production")
        ]
    }

    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}
