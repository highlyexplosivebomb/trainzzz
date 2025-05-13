//
//  AlarmRoute.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//
import CoreLocation

enum AlarmRoute: Hashable {
    case journey(target: MapCoordinate, radius: CLLocationDistance, name: String)
    case arrival
}
