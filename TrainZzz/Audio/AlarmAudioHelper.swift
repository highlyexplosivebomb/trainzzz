//
//  AlarmAudioHelper.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
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
            try session.setActive(true)
        } catch {
            print("Error configuring audio session.")
        }
    }

    public func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("Alarm sound file not found.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Failed to play alarm")
        }
    }

    public func stopAlarmSound() {
        audioPlayer?.stop()
    }
}
