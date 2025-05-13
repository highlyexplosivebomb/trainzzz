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

    @Published var isInRegion: Bool = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    init(audioHelper: AlarmAudioHelper) {
        self.audioHelper = audioHelper
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true

        self.authorisationStatus = locationManager.authorizationStatus
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorisationStatus = status
        print("Authorisation changed: \(status.rawValue)")
    }

    public func startMonitoringRegion(targetCoordinates: CLLocationCoordinate2D, targetRadius: CLLocationDistance) {
        clearCurrentRegion()
        
        // Start monitoring
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: targetCoordinates, radius: targetRadius, identifier: "TargetRegion")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)
            print("Started monitoring region")

            // Logic for if we start off in the region
            if let current = locationManager.location, region.contains(current.coordinate) {
                print("Already in region, alarm activating")
                handleRegionEntry()
            }
        } else {
            print("Issue starting region monitoring")
        }
    }
    
    public func stopMonitoringRegion() {
        clearCurrentRegion()
        isInRegion = false
    }
    
    private func clearCurrentRegion() {
        for region in locationManager.monitoredRegions {
            if let circular = region as? CLCircularRegion, circular.identifier == "TargetRegion" {
                locationManager.stopMonitoring(for: circular)
                print("Stopped monitoring previous region")
            }
        }
    }
    
    public func request() {
        locationManager.requestAlwaysAuthorization()
    }
    
    public func getCurrentLocation() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate // note the location can be null if there is no location avaliable yet
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
}
