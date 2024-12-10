//
//  SolarDetailsView.swift
//  Solar Lens Watch App
//
//  Created by Marc Dürst on 09.12.2024.
//

import SwiftUI

struct SolarDetailsView: View {
    @StateObject var viewModel = SolarDetailsViewModel()

    var body: some View {
        ZStack {

            LinearGradient(
                gradient: Gradient(colors: [
                    .orange.opacity(0.5), .orange.opacity(0.2),
                ]), startPoint: .top, endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                Grid {
                    let currentProduction =
                        Double(
                            viewModel.overviewData.currentSolarProduction)
                        / 1000

                    let todayProduction =
                        Double(
                            viewModel.solarDetailsData.todaySolarProduction ?? 0
                        )
                        / 1000

                    GridRow(alignment: .firstTextBaseline) {
                        Text("Current")
                            .frame(maxWidth: .infinity)

                        Text(
                            String(
                                format: "%.1f kW",
                                currentProduction)
                        )
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                    }

                    GridRow {
                        Text("Today")
                            .frame(maxWidth: .infinity)

                        Text(
                            String(
                                format: "%.1f kW",
                                todayProduction)
                        )
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                    }

                }  // :Grid

                Divider()

                Text("Forecast")
                    .font(.headline)
                    .padding(.top, 4)

                Grid {

                    GridRow {
                        Text("Today")
                            .frame(maxWidth: .infinity)
                            .gridColumnAlignment(.leading)

                        Text(
                            String(
                                format: "%.0f kWh",
                                viewModel.solarDetailsData.forecastToday ?? 0)
                        )
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                    }  // :GridRow

                    GridRow(alignment: .firstTextBaseline) {
                        Text("Tomorrow")
                            .frame(maxWidth: .infinity)

                        Text(
                            String(
                                format: "%.0f kWh",
                                viewModel.solarDetailsData.forecastTomorrow ?? 0
                            )
                        )
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                    }  // :GridRow

                    let afterTomorrow = Calendar.current.startOfDay(
                        for: Calendar.current.date(
                            byAdding: .day, value: 2, to: Date())!)

                    GridRow(alignment: .firstTextBaseline) {
                        Text(
                            afterTomorrow,
                            formatter: getDateFormatter()
                        )
                        .frame(maxWidth: .infinity)

                        Text(
                            String(
                                format: "%.0f kWh",
                                viewModel.solarDetailsData
                                    .forecastDayAfterTomorrow ?? 0)
                        )
                        .foregroundColor(.accent)
                        .frame(maxWidth: .infinity)
                    }  // :GridRow
                }  // :Grid
            }  // :ScrollView

            if viewModel.isLoading {
                ProgressView()
            }

        }  // :ZStack
        .onAppear {
            Task {
                await viewModel.fetchSolarDetails()
            }
        }
    }

    private func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }
}

#Preview {
    SolarDetailsView()
}
