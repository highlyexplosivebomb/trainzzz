//
//  AlarmAudioHelper.swift
//  TrainZzz
//
//  Created by Justin Wong on 11/5/2025.
//

import SwiftUI
import AVFoundation
import AudioToolbox

class AlarmAudioHelper: ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        DispatchQueue.main.async {
            self.configureAudioSession()
        }
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            print("Audio session category set")
        } catch {
            print("setCategory failed: \(error)")
        }

        do {
            try session.setActive(true)
            print("Audio session activated")
        } catch {
            print("setActive failed: \(error)")
        }
    }

    public func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("Alarm sound file not found.")
            return
        }
        
        print("alarm.mp3 file URL: \(url)")

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop until stopped
            audioPlayer?.play()
        } catch {
            print("Failed to play alarm: \(error)")
        }
    }

    public func stopAlarmSound() {
        audioPlayer?.stop()
    }
}

