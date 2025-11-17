//
//  TimerActiveBanner.swift
//  YUBIDI
//
//  Created by Matilde Davide on 17/11/25.
//

import SwiftUI

// Banner che mostra il timer attivo + bottone Cancel
struct TimerActiveBanner: View {
    let time: Date
    let onCancel: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Timer Active")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Music will stop at \(time, style: .time)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onCancel) {
                Text("Cancel")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .buttonStyle(.bordered)
            .tint(.indigo)
        }
        .padding()
        .background(Color(.systemIndigo).opacity(0.10))
        .cornerRadius(12)
    }
}
