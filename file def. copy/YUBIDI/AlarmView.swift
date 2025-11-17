//
//  AlarmView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 12/11/25.
//

import SwiftUI
import UserNotifications

struct AlarmPickerView: View {
    
   @Binding var selectedTime: Date
        @State private var isTimerActive = false
        @State private var scheduledTime: Date?
        @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.top, -200)
            
            Text("The music will stop at the selected time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 15)
            
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    

}


//#Preview {
//    AlarmPickerView()
//}
