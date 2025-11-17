//
//  CerteNottiView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 17/11/25.
//


import SwiftUI
import AVFoundation
import Observation

struct MusicPlayerView: View {
       
    @State private var player = AudioPlayer()
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Album artwork
                Image("Certe notti cover")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320, height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 20)
                
                // Song info
                VStack(spacing: 8) {
                    Text("Certe Notti")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Ligabue")
                        .font(.body)
                }
                
                // Progress bar
                VStack(spacing: 8) {
                    ProgressView(value: player.currentTime, total: player.duration)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                    
                    HStack {
                        Text(timeString(time: player.currentTime))
                            .font(.caption)
                        
                        Spacer()
                        
                        Text(timeString(time: player.duration))
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 30)
                
                // Controls
                HStack(spacing: 40) {
                    Button(action: {
                        player.skipBackward()
                    }) {
                        Image(systemName: "15.arrow.trianglehead.counterclockwise")
                            .font(.system(size: 30))
                            .foregroundColor(.indigo.opacity(0.9))
                    }
                    
                    Button(action: {
                        player.togglePlayPause()
                    }) {
                        Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.indigo.opacity(0.9))
                    }
                    
                    Button(action: {
                        player.skipForward()
                    }) {
                        Image(systemName: "15.arrow.trianglehead.clockwise")
                            .font(.system(size: 30))
                            .foregroundColor(.indigo.opacity(0.9))
                    }
                }
                .padding(.bottom, 20)
                
                // Volume control
                HStack(spacing: 15) {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $player.volume, in: 0...1)
                        .tint(.indigo.opacity(0.9))
                    
                    Image(systemName: "speaker.wave.3.fill")
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .background(Color(.secondarySystemBackground))
        }
        .onAppear {
            player.setupAudio()
        }
    }
    
    func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

@Observable
class AudioPlayer {
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var volume: Float = 0.5 {
        didSet {
            audioPlayer?.volume = volume
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    
    func setupAudio() {
        print("Setting up audio...")

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("Audio session configured")
        } catch {
            print("Failed to set audio session category: \(error)")
        }

        // Cerca direttamente "music.mp3"
        guard let audioURL = Bundle.main.url(forResource: "certe_notti_base", withExtension: "mp3") else {
            print("Audio file 'music.mp3' not found in bundle")
            return
        }

        print("Found audio file at: \(audioURL.lastPathComponent)")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = volume
            duration = audioPlayer?.duration ?? 0
            print("Audio loaded successfully - Duration: \(duration) seconds")
        } catch {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }
    func togglePlayPause() {
        guard let player = audioPlayer else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
            stopTimer()
        } else {
            player.play()
            isPlaying = true
            startTimer()
        }
    }
    
    func seek(to time: Double) {
        audioPlayer?.currentTime = time
    }
    
    func skipForward() {
        guard let player = audioPlayer else { return }
        let newTime = min(player.currentTime + 15, duration)
        player.currentTime = newTime
        currentTime = newTime
    }
    
    func skipBackward() {
        guard let player = audioPlayer else { return }
        let newTime = max(player.currentTime - 15, 0)
        player.currentTime = newTime
        currentTime = newTime
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer else { return }
            self.currentTime = player.currentTime
            
            if !player.isPlaying && self.isPlaying {
                self.isPlaying = false
                self.stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
