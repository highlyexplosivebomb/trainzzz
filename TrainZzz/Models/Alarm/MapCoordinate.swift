//
//  MapCoordinate.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//
import CoreLocation

struct MapCoordinate: Hashable, Equatable {
    let latitude: Double
    let longitude: Double
    
    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(coord: CLLocationCoordinate2D) {
        self.latitude = coord.latitude
        self.longitude = coord.longitude
    }
}
