//
//  Settings.swift
//  SolarManagerWatch Watch App
//
//  Created by Marc Dürst on 11.10.2024.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var model: BuildingStateViewModel

    var body: some View {
        VStack(alignment: .center) {
            Text("Settings")
                .font(.title)
                .foregroundColor(.blue)
                .padding(.bottom, 16)

            Text(
                "\(KeychainHelper.loadCredentials().username ?? "-")"
            )
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding(.bottom, 16)

            Button("Log out") {
                model.logout()
            }

            VStack {
                Text(
                    "Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
                )

                Text(
                    "Build: \(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")"
                )
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.footnote)
            .foregroundColor(.gray)
            .padding(.top, 16)
        }

    }
}

#Preview {
    Settings()
        .environmentObject(
            BuildingStateViewModel(
                energyManagerClient: FakeEnergyManager()
            ))
}
