//
//  ChargingControlView.swift
//  SolarManagerWatch Watch App
//
//  Created by Marc Dürst on 25.10.2024.
//

import SwiftUI

struct ChargingControlView: View {
    @EnvironmentObject var model: BuildingStateViewModel
    @State var newCarCharging: ControlCarChargingRequest? = nil

    var body: some View {
        NavigationStack {
            ScrollView {

                Spacer()

                ForEach($model.overviewData.chargingStations, id: \.id) {
                    chargingStation in

                    VStack(alignment: .leading, spacing: 3)
                    {
                        ChargingStationModeView(
                            isTheOnlyOne: .constant(model.overviewData.chargingStations.count <= 1),
                            chargingStation: chargingStation)
                    }
                } // :ForEach
                
            } // :ScrollView
            .navigationTitle("Charging")
            .navigationBarTitleDisplayMode(.inline)
            
        } // :NavigationStack
    } // :Body
} // :View

#Preview {
    ChargingControlView()
        .environmentObject(
            BuildingStateViewModel.fake(
                overviewData: .init(
                    currentSolarProduction: 4550,
                    currentOverallConsumption: 1200,
                    currentBatteryLevel: 78,
                    currentBatteryChargeRate: 3400,
                    currentSolarToGrid: 10,
                    currentGridToHouse: 0,
                    currentSolarToHouse: 1200,
                    solarProductionMax: 11000,
                    hasConnectionError: false,
                    lastUpdated: Date(),
                    isAnyCarCharing: false,
                    chargingStations: [
                        .init(
                            id: "42",
                            name: "Keba",
                            chargingMode: ChargingMode.withSolarPower,
                            priority: 1,
                            currentPower: 0,
                            signal: SensorConnectionStatus.connected)
                    ]
                )
            ))
}
