//
//  AlarmJourneyViewModel.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//

import Foundation
import CoreLocation

class AlarmJourneyViewModel: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D
    @Published var distanceFromDestination: String = "Calculating..."
    @Published var nearestStation: String = "Calculating..."
    
    public let targetCoordinates: CLLocationCoordinate2D
    public let targetRadius: CLLocationDistance
    public let heading: String
    
    private var locationManager: AppLocationManager?
    private var timer: Timer?
    private var stationManager = StationManager()
    
    init(currentLocation: CLLocationCoordinate2D, targetCoordinates: CLLocationCoordinate2D, targetRadius: CLLocationDistance, destinationName: String) {
        self.currentLocation = currentLocation
        self.targetCoordinates = targetCoordinates
        self.targetRadius = targetRadius
        self.heading = "My Current Trip to \(destinationName)"
    }
    
    func getAndSetLocationManager(manager: AppLocationManager) {
        self.locationManager = manager
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
    
    func tick() {
        guard let newLocation = locationManager?.getCurrentLocation() else { return }
        currentLocation = newLocation
        distanceFromDestination = calculateDistanceToDestinationString(currentLocation: currentLocation)
        nearestStation = calculateNearestStationString(currentLocation: currentLocation)
    }
    
    func calculateDistanceToDestinationString(currentLocation: CLLocationCoordinate2D) -> String {
        let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let target = CLLocation(latitude: targetCoordinates.latitude, longitude: targetCoordinates.longitude)
        let distance = current.distance(from: target)
        
        if distance >= 1000 {
            return String(format: "%.1f km", distance / 1000)
        } else {
            return "\(Int(distance)) m"
        }
    }
    
    func calculateNearestStationString(currentLocation: CLLocationCoordinate2D) -> String {
        stationManager.fetchStations(currentLocation: currentLocation, radiusInMetres: 2000)
        return stationManager.stations.first?.name ?? "Your nearest station is over 2km away."
    }

    func onDestroyed() {
        timer?.invalidate()
        timer = nil
        locationManager?.stopMonitoringRegion()
    }
}
