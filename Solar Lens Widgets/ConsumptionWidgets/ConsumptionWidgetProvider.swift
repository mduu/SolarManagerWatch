//
//  SolarProductionProvider.swift
//  Solar Lens Watch App
//
//  Created by Marc Dürst on 22.11.2024.
//

import Foundation
import WidgetKit

struct ConsumptionWidgetProvider: AppIntentTimelineProvider {
    let solarManager = SolarManager()

    func placeholder(in context: Context) -> ConsumptionEntry {
        return .previewData()
    }

    func snapshot(
        for configuration: ConsumptionAppIntent, in context: Context
    ) async -> ConsumptionEntry {

        if context.isPreview {
            // A complication with generic data for preview
            return .previewData()
        }

        let data = try? await solarManager.fetchOverviewData(
            lastOverviewData: nil)
        
        print("Snapshot-Data \(data?.currentOverallConsumption ?? 0)")

        return ConsumptionEntry(
            date: Date(),
            currentConsumption: data?.currentOverallConsumption,
            carCharging: data?.isAnyCarCharing,
            consumptionFromSolar: data?.currentSolarToHouse,
            consumptionFromBattery: data?.currentBatteryChargeRate ?? 0 * -1,
            consumptionFromGrid: data?.currentGridToHouse)
    }

    func timeline(
        for configuration: ConsumptionAppIntent, in context: Context
    ) async -> Timeline<ConsumptionEntry> {
        var entries: [ConsumptionEntry] = []

        if context.isPreview {
            // A complication with generic data for preview
            entries.append(.previewData())
        } else {
            let data = try? await solarManager.fetchOverviewData(
                lastOverviewData: nil)

            print("Timeline-Data \(data?.currentOverallConsumption ?? -1)")

            entries.append(
                ConsumptionEntry(
                    date: Date(),
                    currentConsumption: data?.currentOverallConsumption,
                    carCharging: data?.isAnyCarCharing,
                    consumptionFromSolar: data?.currentSolarToHouse,
                    consumptionFromBattery: data?.currentBatteryChargeRate ?? 0 * -1,
                    consumptionFromGrid: data?.currentGridToHouse))
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<
        ConsumptionAppIntent
    >] {
        // Create an array with all the preconfigured widgets to show.
        [
            AppIntentRecommendation(
                intent: ConsumptionAppIntent(),
                description: "Current Consumption")
        ]
    }

    //    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}