//
//  CircularInstrument.swift
//  SolarManagerWatch Watch App
//
//  Created by Marc Dürst on 17.10.2024.
//

import SwiftUI

struct CircularInstrument: View {
    @Binding var color: Color
    @Binding var largeText: String
    @Binding var smallText: String?

    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 4)
                .frame(maxWidth: 45)
            VStack {
                Text(largeText)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .padding(.top, 6)

                if smallText != nil {
                    Text(smallText!)
                        .font(.system(size: 9))
                        .padding(.bottom, 4)
                }
            }
        }
    }
}

#Preview {
    CircularInstrument(
        color: Binding<Color>.constant(.yellow),
        largeText: Binding<String>.constant("45"),
        smallText: Binding<String?>.constant("kW"))
}
