//
//  HomeView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 10/11/25.
//

import SwiftUI

struct HomeView: View {
    // Sheet state
    @State private var showTimerSheet = false
    @State private var selectedTime = Date()
    @State private var isTimerActive = false
    @State private var scheduledTime: Date?
    
    // Sample data
    private let topPicks = [
        Album(title: "Forse", subtitle: "Tommaso Paradiso", imageName: "Tommaso cover"),
        Album(title: "FOTOGRAFIA", subtitle: "Geolier", imageName: "Geolier cover"),
        Album(title: "Esibizionista", subtitle: "Annalisa", imageName: "Annalisa cover"),
    ]
    
    private let recentlyPlayed = [
        Album(title: "Vasco Rossi", imageName: "Vasco Rossi"),
        Album(title: "Adriano Celentano", imageName: "Adriano Celentano"),
        Album(title: "Ligabue", imageName: "Ligabue"),
    ]
    
    private let recommended = [
        Album(title: "Sally", subtitle: "Vasco Rossi", imageName: "Sally cover"),
        Album(title: "Azzurro", subtitle: "Adriano Celentano", imageName: "Azzurro cover"),
        Album(title: "Certe Notti", subtitle: "Ligabue", imageName: "Certe notti cover"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    //Timer Active Banner - ADD THIS
                                        if isTimerActive, let time = scheduledTime {
                                            TimerActiveBanner(time: time) {
                                                cancelTimer()
                                            }
                                            .padding(.horizontal)
                                        }
                    SectionView2(
                        sectionTitle: "New songs of the week!",
                        albums: topPicks
                    )
                    SectionView(
                        sectionTitle: "Your top artists",
                        albums: recentlyPlayed
                    )
                    SectionView2(
                        sectionTitle: "Your top songs",
                        albums: recommended
                    )
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showTimerSheet.toggle()
                    } label: {
                        Image(systemName: "timer")
                            .foregroundStyle(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showTimerSheet) {
                NavigationStack {
                    AlarmPickerView(selectedTime: $selectedTime)
                        .navigationTitle("Timer")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    startTimer(at: selectedTime)
                                    showTimerSheet.toggle()
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(.indigo))
                                
                                
                            }
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showTimerSheet = false
                                } label: {
                                    Image(systemName: "xmark")
                                    
                                }
                            }
                        }
                }
                .padding()
                .presentationDetents([.large])
                
            }
            .navigationTitle("Home")
            .background(Color(.secondarySystemBackground))
        }
    }
    
    func startTimer(at time: Date) {
        scheduledTime = time
        isTimerActive = true
        
        // Schedule notification
                    scheduleNotification(for: time)
        
        print("Timer started for: \(time.formatted(date: .omitted, time: .shortened))")
    }
    func cancelTimer() {
            isTimerActive = false
            scheduledTime = nil
    
            // Cancel all pending notifications
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    
            print("Timer cancelled")
        }
    
        func scheduleNotification(for date: Date) {
            // Request notification permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    let content = UNMutableNotificationContent()
                    content.title = "Music Timer"
                    content.body = "Time to stop the music!"
                    content.sound = .default
    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    
                    let request = UNNotificationRequest(
                        identifier: "musicTimer",
                        content: content,
                        trigger: trigger
                    )
    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification: \(error.localizedDescription)")
                        } else {
                            print("Notification scheduled successfully")
                        }
                    }
                } else if let error = error {
                    print("Permission error: \(error.localizedDescription)")
                }
            }
        }
    }


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
        .background(.indigo.opacity(0.1))
        .cornerRadius(12)
    }
}




#Preview {
    HomeView()
}
