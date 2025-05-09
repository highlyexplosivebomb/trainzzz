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

class SetupLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        self.authorisationStatus = locationManager.authorizationStatus
        // locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorisationStatus = status
        print("🔐 Authorization changed: \(status.rawValue)")

        switch status {
        case .authorizedAlways:
            print("✅ Authorized Always – start monitoring region")

        case .authorizedWhenInUse:
            print("⚠️ Only When In Use – background geofencing won't work")

        case .denied, .restricted:
            print("❌ Location permission denied/restricted")

        case .notDetermined:
            print("⏳ Waiting for user to decide")

        @unknown default:
            break
        }
    }
    
    public func request() {
        locationManager.requestAlwaysAuthorization()
    }
}

