//
//  AudioPlayer.swift
//  YUBIDI2
//
//  Created by Matilde Davide on 17/11/25.
//

import Observation
import AVFoundation

@Observable
class AudioPlayer {
    static let shared = AudioPlayer()
    
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
    
        private init() {}
    
        func setupAudio() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Audio error: \(error)")
            }
            
            guard let url = Bundle.main.url(forResource: "certe_notti_base", withExtension: "mp3") else {
                print("File not found")
                return
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                duration = audioPlayer?.duration ?? 0
            } catch {
                print("Load error: \(error)")
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
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                guard let player = self.audioPlayer else { return }
                self.currentTime = player.currentTime
            }
        }
    
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
}
