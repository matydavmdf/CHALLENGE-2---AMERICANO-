//
//  HomeView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 10/11/25.
//

import SwiftUI
import AVFoundation
import UserNotifications

struct HomeView: View {
    
    @State private var showTimerSheet = false
    @State private var selectedTime = Date()
    @State private var isTimerActive = false
    @State private var scheduledTime: Date?
    @State private var stopTimer: Timer?
    
    @State private var audioPlayer: AVAudioPlayer?
    
    
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
                                    showTimerSheet = false
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
               
                .presentationDetents([.large])
                
            }
            .navigationTitle("Home")
            .background(Color(.secondarySystemBackground))
            .onAppear {
                startMusicPlayback()
                // Avvia musica (demo)
            }
        }
    }
    // MARK: - MUSIC CONTROL ---------------------------------------
    func startMusicPlayback() {
        guard let url = Bundle.main.url(forResource: "song", withExtension: "mp3") else {
            print("song.mp3 non trovato nel Bundle")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1   // loop infinito
            audioPlayer?.play()
            print("Musica avviata")
            
        } catch {
            print("Errore audio:", error.localizedDescription)
        }
    }
 
//    / MARK: - TIMER FUNCTIONS ------------------------------------
    
    func startTimer(at time: Date) {
        scheduledTime = time
        isTimerActive = true
        
        scheduleNotification(for: time)
        
        stopTimer?.invalidate()
        
        let seconds = max(0, time.timeIntervalSinceNow)
        
        print("Timer partirà tra \(seconds) secondi")
        
        // Pianifica STOP MUSICA reale
        stopTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            stopMusic()
        }
        
        print("Timer attivo fino alle \(time.formatted(date: .omitted, time: .shortened))")
    }
    
    
    func stopMusic() {
        print("Musica fermata dal Timer")
        audioPlayer?.stop()
        audioPlayer = nil
        cancelTimer()
    }
    
    
    func cancelTimer() {
        isTimerActive = false
        scheduledTime = nil
        stopTimer?.invalidate()
        stopTimer = nil
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        print("Timer cancellato")
    }
    
    
    func scheduleNotification(for date: Date) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            
            guard granted else {
                print("Notifiche non autorizzate")
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Music Timer"
            content.body = "Time to stop the music!"
            content.sound = .default
            
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.hour, .minute], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "musicTimer",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
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
