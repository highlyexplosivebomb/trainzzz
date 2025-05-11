//
//  SetupLocationManager.swift
//  TrainZzz
//
//  Created by Justin Wong on 9/5/2025.
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
        // startMonitoringRegion()
    }
    
    ////        #if targetEnvironment(simulator)
    ////        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    ////            print("Simulating region entry in simulator...")
    ////            let mockRegion = CLCircularRegion(
    ////                center: self.targetCoordinate,
    ////                radius: self.radius,
    ////                identifier: "TargetRegion"
    ////            )
    ////            self.locationManager(self.locationManager, didEnterRegion: mockRegion)
    ////        }
    ////        #endif
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorisationStatus = status
        print("Authorization changed: \(status.rawValue)")

        switch status {
        case .authorizedAlways:
            print("Authorized Always – start monitoring region")
            //startMonitoringRegion()

        case .authorizedWhenInUse:
            print("Only When In Use – background geofencing won't work")

        case .denied, .restricted:
            print("Location permission denied/restricted")

        case .notDetermined:
            print("Waiting for user to decide")

        @unknown default:
            break
        }
    }
    
    public func request() {
        locationManager.requestAlwaysAuthorization()
    }
    
    public func startMonitoringRegion() {
        // Clear any existing region
        for region in locationManager.monitoredRegions {
            if let circular = region as? CLCircularRegion, circular.identifier == "TargetRegion" {
                locationManager.stopMonitoring(for: circular)
                print("🧹 Stopped monitoring previous region")
                }
        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: targetCoordinate, radius: radius, identifier: "TargetRegion")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            print("📍 Started monitoring region")

            // Manually trigger if already inside
            if let current = locationManager.location, region.contains(current.coordinate) {
                print("🟢 Already in region — manually triggering alarm")
                handleRegionEntry()
            }
        } else {
            print("❌ Region monitoring not available")
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered any region: \(region.identifier)")
        guard region.identifier == "TargetRegion" else { return }
        handleRegionEntry()
    }
    
    private func handleRegionEntry() {
        print("Entered region — attempting to play alarm")

        withBackgroundTask(named: "PlayAlarm") {
            print("background task started")
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

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region.identifier == "TargetRegion" else { return }
        isInRegion = false
        print("i have left region")
    }
    
    // remove these methods, the audio helper should be passed in possibly injected as an environment object.
    public func playAlarmSound() {
        audioHelper.playAlarmSound()
    }
    
    public func stopAlarmSound() {
        audioHelper.stopAlarmSound()
    }
}

