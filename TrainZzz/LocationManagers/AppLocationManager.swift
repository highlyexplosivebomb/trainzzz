//
//  AppLocationManager.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI
import CoreLocation
import AVFoundation
import AudioToolbox

class AppLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let audioHelper: AlarmAudioHelper
    // Temp variables
    private let targetCoordinate = CLLocationCoordinate2D(latitude: -33.863400, longitude: 151.210500) // Example: Sydney
    private let radius: CLLocationDistance = 100.0 // meters

    @Published var isInRegion: Bool = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    init(audioHelper: AlarmAudioHelper) {
        self.audioHelper = audioHelper
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true

        self.authorisationStatus = locationManager.authorizationStatus
        locationManager.startUpdatingLocation() // this should be called by VM as needed
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorisationStatus = status
        print("Authorisation changed: \(status.rawValue)")
    }

    public func startMonitoringRegion() {
        // Clear the TargetRegion region
        for region in locationManager.monitoredRegions {
            if let circular = region as? CLCircularRegion, circular.identifier == "TargetRegion" {
                locationManager.stopMonitoring(for: circular)
                print("Stopped monitoring previous region")
                }
        }
        
        // Start monitoring the new region
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: targetCoordinate, radius: radius, identifier: "TargetRegion")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            print("Started monitoring region")

            // If we're already in the region, trigger the alarm
            if let current = locationManager.location, region.contains(current.coordinate) {
                print("Already in region, alarm activating")
                handleRegionEntry()
            }
        } else {
            print("Issue starting region monitoring")
        }
    }

    public func request() {
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region.identifier == "TargetRegion" else { return }
        handleRegionEntry()
        print("Entering region...")
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region.identifier == "TargetRegion" else { return }
        isInRegion = false
        print("Exiting region...")
    }

    private func handleRegionEntry() {
        withBackgroundTask(named: "PlayAlarm") {
            print("Background task started")
            self.isInRegion = true
            self.audioHelper.playAlarmSound()
        }
    }

    func withBackgroundTask(named name: String, delay: TimeInterval = 5.0, execute: @escaping () -> Void) {
        var taskID: UIBackgroundTaskIdentifier = .invalid

        let expirationHandler: () -> Void = {
            if taskID != .invalid {
                UIApplication.shared.endBackgroundTask(taskID)
            }
        }

        taskID = UIApplication.shared.beginBackgroundTask(withName: name, expirationHandler: expirationHandler)

        execute()

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if taskID != .invalid {
                UIApplication.shared.endBackgroundTask(taskID)
            }
        }
    }

    // Use the audio helper to start and stop the alarm
    public func playAlarmSound() {
        audioHelper.playAlarmSound()
    }

    public func stopAlarmSound() {
        audioHelper.stopAlarmSound()
    }
}
