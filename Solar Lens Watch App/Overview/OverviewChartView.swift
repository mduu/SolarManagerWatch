import SwiftUI

struct OverviewChartView: View {
    @EnvironmentObject var buildingModel: BuildingStateViewModel
    @StateObject var viewModel = OverviewChartViewModel()
    @State private var refreshTimer: Timer?

    var body: some View {
        ZStack {
            
            VStack {
                if viewModel.error == nil && viewModel.errorMessage == nil {
                    
                    if viewModel.consumptionData != nil {
                        
                        ZStack {
                            
                            VStack {
                                OverviewChart(
                                    consumption: .constant(viewModel.consumptionData!)
                                )
                                
                                HStack {
                                    Text("Max \(Image(systemName: "sun.max")) =")
                                        .font(.footnote)
                                    Text(String(format: "%.2f kWp", getMaxProductionkW()))
                                        .font(.footnote)
                                        .foregroundColor(.yellow)
                                }
                                
                                HStack {
                                    Text("Max \(Image(systemName: "house")) =")
                                        .font(.footnote)
                                    Text(String(format: "%.2f kWp", getMaxConsumptionkW()))
                                        .font(.footnote)
                                        .foregroundColor(.teal)
                                }
                            }
                            
                            VStack {
                                HStack {
                                    Text("Self consumption:")
                                        .font(.footnote)
                                    Text(String(format: "%.0f%%", buildingModel.overviewData.todaySelfConsumptionRate ?? 0))
                                        .font(.footnote)
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                        } // :ZStack

                    } else {
                        
                        Spacer()
                        Text("No data")
                            .font(.footnote)
                        Spacer()
                        
                    }
                    
                } // :if
            } // :VStack
            .padding(8)
            .ignoresSafeArea(edges: .horizontal.union(.bottom))

            if viewModel.isLoading {
                ProgressView()
                    .tint(.accent)
                    .padding()
                    .foregroundStyle(.accent)
                    .background(Color.black.opacity(0.7))
            }
        }  // :ZStack
        .onAppear {
            Task {
                await viewModel.fetch()
                
                if refreshTimer == nil {
                    refreshTimer = Timer.scheduledTimer(
                        withTimeInterval: 300, repeats: true
                    ) {
                        _ in
                        Task {
                            await viewModel.fetch()
                        }
                    }  // :refreshTimer
                }  // :if
            } // :Task
        } // :onAppear
        .onDisappear {
            if (refreshTimer != nil) {
                refreshTimer?.invalidate()
                refreshTimer = nil
            }
        } // :onDisappear
    }
    
    private func getMaxProductionkW() -> Double {
        guard let consumptionData = viewModel.consumptionData else { return 0 }
        guard consumptionData.data.isEmpty == false else { return 0 }
        
        let maxProduction: Double? = consumptionData.data
            .map { $0.productionWatts / 1000 }
            .max()

        guard let maxProduction else { return 0 }

        return maxProduction
    }
    
    private func getMaxConsumptionkW() -> Double {
        guard let consumptionData = viewModel.consumptionData else { return 0 }
        guard consumptionData.data.isEmpty == false else { return 0 }
        
        let maxConsumption: Double? = consumptionData.data
            .map { $0.consumptionWatts / 1000 }
            .max()

        guard let maxConsumption else { return 0 }

        return maxConsumption
    }
}

#Preview {
    OverviewChartView(
        viewModel: OverviewChartViewModel.previewFake()
    )
    .environmentObject(BuildingStateViewModel.fake(overviewData: OverviewData()))
}
