import SwiftUI
import WidgetKit

struct ConsumptionWidget: Widget {
    let kind: String = "SolarLens-Consumption-Current"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConsumptionAppIntent.self,
            provider: ConsumptionWidgetProvider()
        ) { entry in
            ConsumptionWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Consumption")
        .description("Shows the current energy consumption.")
        .supportedFamilies([
            .accessoryCorner, .accessoryCircular, .accessoryInline, .accessoryRectangular
        ])
    }
}
