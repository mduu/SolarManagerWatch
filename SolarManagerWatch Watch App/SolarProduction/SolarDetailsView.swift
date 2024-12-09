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
                VStack {
                    Grid {
                        let currentProduction =
                            Double(
                                viewModel.overviewData.currentSolarProduction)
                            / 1000

                        let todayProduction =
                            Double(
                                viewModel.solarDetailsData.todaySolarProduction ?? 0)
                            / 1000

                        GridRow(alignment: .firstTextBaseline) {
                            Text("Current")
                                .frame(maxWidth: .infinity)
                                .gridColumnAlignment(.trailing)

                            Text(
                                String(
                                    format: "%.1f kW",
                                    currentProduction)
                            )
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                        }

                        GridRow(alignment: .firstTextBaseline) {
                            Text("Today")
                                .frame(maxWidth: .infinity)
                                .gridColumnAlignment(.trailing)

                            Text(
                                String(
                                    format: "%.1f kW",
                                    todayProduction)
                            )
                            .foregroundColor(.accent)
                            .frame(maxWidth: .infinity)
                        }

                    }  // :Grid
                }  // :VStack
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
}

#Preview {
    SolarDetailsView()
}
