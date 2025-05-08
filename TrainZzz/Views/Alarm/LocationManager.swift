//
//  LocationManager.swift
//  TrainZzz
//
//  Created by Justin Wong on 8/5/2025.
//

import SwiftUI
import CoreLocation
import AVFoundation
import AudioToolbox

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let targetCoordinate = CLLocationCoordinate2D(latitude: -33.865143, longitude: 151.209900) // Example: Sydney
    private let radius: CLLocationDistance = 100.0 // meters

    @Published var isInRegion: Bool = false
    
    private var audioPlayer: AVAudioPlayer?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        startMonitoringRegion()
        
        #if targetEnvironment(simulator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("Simulating region entry in simulator...")
            let mockRegion = CLCircularRegion(
                center: self.targetCoordinate,
                radius: self.radius,
                identifier: "TargetRegion"
            )
            self.locationManager(self.locationManager, didEnterRegion: mockRegion)
        }
        #endif
    }

    private func startMonitoringRegion() {
        print("monitoring")
        let region = CLCircularRegion(center: targetCoordinate, radius: radius, identifier: "TargetRegion")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        locationManager.startMonitoring(for: region)
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered any region: \(region.identifier)")
        if region.identifier == "TargetRegion" {
            isInRegion = true
            print("I'm there")
            playAlarmSound() // Example alarm sound
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "TargetRegion" {
            isInRegion = false
            print("im not there")
        }
    }
    
    public func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            print("Alarm sound file not found.")
            return
        }

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
