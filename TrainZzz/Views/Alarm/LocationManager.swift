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
    private let targetCoordinate = CLLocationCoordinate2D(latitude: -33.863400, longitude: 151.210500) // Example: Sydney
    private let radius: CLLocationDistance = 100.0 // meters

    @Published var isInRegion: Bool = false
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined

    private var audioPlayer: AVAudioPlayer?

//    override init() {
//        super.init()
//        locationManager.delegate = self
//        self.authorisationStatus = locationManager.authorizationStatus
//        
//        if authorisationStatus == .notDetermined {
//            locationManager.requestAlwaysAuthorization()
//        }
//        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//        startMonitoringRegion()
//        DispatchQueue.main.async {
//            self.configureAudioSession()
//        }
//        
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
//    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        self.authorisationStatus = locationManager.authorizationStatus
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        DispatchQueue.main.async {
            self.configureAudioSession()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorisationStatus = status
        print("🔐 Authorization changed: \(status.rawValue)")

        switch status {
        case .authorizedAlways:
            print("✅ Authorized Always – start monitoring region")
            startMonitoringRegion()

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

    private func startMonitoringRegion() {
        for region in locationManager.monitoredRegions {
            if let circular = region as? CLCircularRegion, circular.identifier == "TargetRegion" {
                locationManager.stopMonitoring(for: circular)
                print("🧹 Stopped existing region monitoring")
            }
        }
        
        print("entered monitoring")
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("i can monitor")
            let region = CLCircularRegion(center: targetCoordinate, radius: radius, identifier: "TargetRegion")
            region.notifyOnEntry = true
            region.notifyOnExit = true
            locationManager.startMonitoring(for: region)

            // 🧠 Check immediately if we're already inside
            if let currentLocation = locationManager.location, region.contains(currentLocation.coordinate) {
                print("🟢 Already inside region on launch — manually triggering alarm")
                isInRegion = true
                playAlarmSound()
            }
        }
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            print("✅ Audio session category set")
        } catch {
            print("❌ setCategory failed: \(error)")
        }

        do {
            try session.setActive(true)
            print("✅ Audio session activated")
        } catch {
            print("❌ setActive failed: \(error)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered any region: \(region.identifier)")
        if region.identifier == "TargetRegion" {
            isInRegion = true
            print("I'm there")
            playAlarmSound()
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
        
        print("✅ alarm.mp3 file URL: \(url)")

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

