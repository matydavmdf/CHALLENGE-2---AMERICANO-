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
    
    @Bindable var player = AudioPlayer.shared
    
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
                
                
                // Song info
                VStack(spacing: 8) {
                    Text("Certe Notti")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Ligabue")
                    
                }
                
                // Progress bar
                VStack(spacing: 8) {
                    ProgressView(value: player.currentTime, total: player.duration)
                        .progressViewStyle(.linear)
                        .scaleEffect(x: 1, y: 2)
                    
                    HStack {
                        Text(timeString(time: player.currentTime))
                        //                            .font(.caption)
                        
                        Spacer()
                        
                        Text(timeString(time: player.duration))
                        //                            .font(.caption)
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
                //                .padding(.bottom, 20)
                
                // Volume control
                HStack(spacing: 15) {
                    Image(systemName: "speaker.fill")
                    
                    Slider(value: $player.volume, in: 0...1)
                    //                        .tint(.indigo.opacity(0.9))
                    
                    Image(systemName: "speaker.wave.3.fill")
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .background(Color(.secondarySystemBackground))
        }
        .onAppear {
            if player.duration == 0 {
                player.setupAudio()
            }
        }
    }
    
    func timeString(time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    
    @Observable
    class AudioPlayer {
        static let shared = AudioPlayer()
        private init() {}
        
        var isPlaying: Bool = false
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
            guard audioPlayer == nil else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio session error: \(error)")
            }
            
            guard let url = Bundle.main.url(forResource: "certe_notti_base", withExtension: "mp3") else {
                print("Audio missing")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = volume
                duration = audioPlayer?.duration ?? 0
            } catch {
                print("Audio load error: \(error)")
            }
        }
        
        
        func togglePlayPause() {
            guard let p = audioPlayer else { return }
            
            if p.isPlaying {
                p.pause()
                isPlaying = false
                stopTimer()
            } else {
                p.play()
                isPlaying = true
                startTimer()
            }
        }
        
        func skipForward() {
            guard let p = audioPlayer else { return }
            let newTime = min(p.currentTime + 15, duration)
            p.currentTime = newTime
            currentTime = newTime
        }
        
        func skipBackward() {
            guard let p = audioPlayer else { return }
            let newTime = max(p.currentTime - 15, 0)
            p.currentTime = newTime
            currentTime = newTime
        }
        
        private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                guard let self, let p = self.audioPlayer else { return }
                self.currentTime = p.currentTime
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
    }
}
