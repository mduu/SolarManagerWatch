import SwiftUI
import WidgetKit

struct SolarProductionWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.showsWidgetLabel) private var showsWidgetLabel
    @Environment(\.showsWidgetContainerBackground)
    var showsWidgetContainerBackground: Bool

    var entry: SolarProductionEntry

    var body: some View {
        let current = Double(entry.currentProduction ?? 0) / 1000
        let max = Double(entry.maxProduction ?? 0) / 1000

        switch family {
            
        case .systemSmall:
            ZStack {
                AccessoryWidgetBackground()

                VStack {
                    Text("Solarproduction")

                    Gauge(
                        value: current,
                        in: 0...max
                    ) {
                        Image(systemName: "sun.max")
                    } currentValueLabel: {
                        Text("\(String(format: "%.1f", current))")
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(renderingMode == .fullColor ? getGaugeStyle() : nil)
                    
                    if entry.forecastToday != nil
                        || entry.forecastTomorrow != nil
                        || entry.forecastDayAfterTomorrow
                            != nil
                    {
                        ForecastListView(
                            maxProduction: entry.maxProduction,
                            forecastToday: entry.forecastToday,
                            forecastTomorrow: entry.forecastTomorrow,
                            forecastDayAfterTomorrow: entry.forecastDayAfterTomorrow,
                            small: true
                        )
                        .padding(.bottom, 4)
                    }  // :if
                }

            }
            .containerBackground(.background, for: .widget)

        case .accessoryCircular:

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
                    }  // :ZStack
                    .widgetLabel {
                        Text("☀️ \(String(format: "%.1f kW", current))")
                    }  // :widgetLabel

                } else {

                    Gauge(
                        value: current,
                        in: 0...max
                    ) {
                        Image(systemName: "sun.max")
                    } currentValueLabel: {
                        Text("\(String(format: "%.1f", current))")
                    }
                    #if os(watchOS)
                        .gaugeStyle(.circular)
                    #else
                        .gaugeStyle(.accessoryCircular)
                    #endif
                    .tint(renderingMode == .fullColor ? getGaugeStyle() : nil)

                }  // :else
            }  // :ZStack
            .containerBackground(for: .widget) { Color.accent }

        #if os(watchOS)
            case .accessoryCorner:

                Text("\(String(format: "%.1f", current)) kW")
                    .foregroundColor(
                        renderingMode == .fullColor
                            ? current > 100 ? .accent : .gray
                            : nil
                    )
                    .widgetCurvesContent()
                    .widgetLabel {
                        Gauge(
                            value: current,
                            in: 0...max
                        ) {
                            Text("kW")
                        } currentValueLabel: {
                            Text("\(String(format: "%.1f", current))")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("\(String(format: "%.0f", max))")
                        }
                        .gaugeStyle(.automatic)
                        .tint(
                            renderingMode == .fullColor ? getGaugeStyle() : nil)
                    }  // :widgetLabel
                    .containerBackground(for: .widget) { Color.accentColor }
        #endif
        case .accessoryInline:

            Text("☀️ \(entry.currentProduction ?? 0) W")
                .containerBackground(for: .widget) { Color.accentColor }

        case .accessoryRectangular, .systemMedium:

            ZStack {
                if !showsWidgetContainerBackground
                    && renderingMode == .fullColor
                {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .orange.opacity(0.5), .orange.opacity(0.3),
                                ]), startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: .infinity, height: .infinity)
                }

                VStack {
                    SolarTodayInfoView(
                        totalProducedToday: .constant(
                            entry.todaySolarProduction),
                        currentProduction: .constant(
                            entry.currentProduction)
                    )

                    if entry.forecastToday != nil
                        || entry.forecastTomorrow != nil
                        || entry.forecastDayAfterTomorrow
                            != nil
                    {
                        ForecastListView(
                            maxProduction: entry.maxProduction,
                            forecastToday: entry.forecastToday,
                            forecastTomorrow: entry.forecastTomorrow,
                            forecastDayAfterTomorrow: entry.forecastDayAfterTomorrow,
                            small: true
                        )
                        .padding(.bottom, 4)
                    }  // :if
                }  // :VStack
            }  // :ZStack
            #if os(iOS)
            .containerBackground(.background, for: .widget)
            #else
            .containerBackground(for: .widget) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .orange.opacity(0.5), .orange.opacity(0.2),
                    ]), startPoint: .top, endPoint: .bottom
                )
            }
            #endif

        default:
            Image("AppIcon")
                .containerBackground(for: .widget) { Color.accentColor }
        }

    }

    func getGaugeStyle() -> Gradient {
        return entry.currentProduction ?? 0 < 50
            ? Gradient(colors: [.gray, .gray])
            : Gradient(colors: [.blue, .yellow, .orange])
    }
}

struct SolarProductionWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for circular
            SolarProductionWidgetView(
                entry: SolarProductionEntry.previewData()
            )
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")

            #if os(watchOS)
                // Preview for corner
                SolarProductionWidgetView(
                    entry: SolarProductionEntry.previewData()
                )
                .previewContext(WidgetPreviewContext(family: .accessoryCorner))
                .previewDisplayName("Corner")
            #endif

            // Preview for inline
            SolarProductionWidgetView(
                entry: SolarProductionEntry.previewData()
            )
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("Inline")

            // Preview for rectangle
            SolarProductionWidgetView(
                entry: SolarProductionEntry.previewData()
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Rectangular")

            #if os(iOS)
                // Preview for .systemSmall
                SolarProductionWidgetView(
                    entry: SolarProductionEntry.previewData()
                )
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Sys Sm.")

                // Preview for .systemMedium
                SolarProductionWidgetView(
                    entry: SolarProductionEntry.previewData()
                )
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Sys Med.")

            #endif
        }
    }
}
