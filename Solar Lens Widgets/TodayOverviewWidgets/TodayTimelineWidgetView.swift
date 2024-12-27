import SwiftUI
import WidgetKit

struct TodayTimelineWidgetView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.widgetRenderingMode) var renderingMode
    @Environment(\.showsWidgetContainerBackground)
    var showsWidgetContainerBackground: Bool

    var entry: TodayTimelineEntry

    var body: some View {
        let current = Double(entry.currentProduction ?? 0) / 1000
        let max =
            Double(entry.history?.data.map { $0.productionWatts }.max() ?? 0)
            / 1000
        let total = Double(entry.todaySolarProduction ?? 0) / 1000

        switch family {

        case .accessoryRectangular:

            ZStack {
                if !showsWidgetContainerBackground
                    && renderingMode == .fullColor
                {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    .gray.opacity(0.3), .gray.opacity(0.2),
                                ]), startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: .infinity, height: .infinity)
                }

                VStack {

                    HStack {
                        Image(systemName: "calendar")
                            .font(.caption)
                        Text(String(format: "%.1f", total))
                            .font(.system(size: 12))
                            .foregroundColor(
                                renderingMode == .fullColor ? .yellow : .primary
                            )
                            .widgetAccentable()

                        Image(systemName: "bolt")
                            .font(.caption)
                        Text(String(format: "%.1f", current))
                            .font(.system(size: 12))
                            .foregroundColor(
                                renderingMode == .fullColor ? .yellow : .primary
                            )
                            .widgetAccentable()

                        Image(systemName: "arrow.up.to.line")
                            .font(.caption)
                        Text(String(format: "%.1f", max))
                            .font(.system(size: 12))
                            .foregroundColor(
                                renderingMode == .fullColor ? .yellow : .primary
                            )
                            .widgetAccentable()
                    }
                    .padding(.top, 3)

                    if let history = entry.history {
                        OverviewChart(
                            consumption: .constant(history),
                            isSmall: true,
                            isAccent: renderingMode == .accented
                        )
                        .ignoresSafeArea()
                        .padding(.horizontal, 6)
                        .padding(.bottom, 4)
                        .padding(.top, -20)
                    }

                }  // :VStack
            }  // :ZStack
            .containerBackground(for: .widget) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        .orange.opacity(0.5), .orange.opacity(0.2),
                    ]), startPoint: .top, endPoint: .bottom
                )
            }

        default:
            Image("AppIcon")
                .containerBackground(for: .widget) { Color.accentColor }
        }

    }

}

struct TodayTimelineWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview for rectangle
            TodayTimelineWidgetView(
                entry: TodayTimelineEntry.previewData()
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("Full Color")

            // Preview for rectangle
            TodayTimelineWidgetView(
                entry: TodayTimelineEntry.previewData()
            )
            .environment(\.widgetRenderingMode, .accented)
            .previewContext(
                WidgetPreviewContext(
                    family: .accessoryRectangular
                )
            )
            .previewDisplayName("Accent")
        }
    }
}
