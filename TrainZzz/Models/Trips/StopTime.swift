//
//  StopTime.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 11/5/2025.
//

struct StopTime: Identifiable {
    var id: String { "\(tripId)-\(stopId)-\(stopSequence)" }

    let tripId: String
    let arrivalTime: String
    let departureTime: String
    let stopId: String
    let stopSequence: Int
    let stopHeadsign: String
    let pickupType: Int
    let dropOffType: Int
    let shapeDistTraveled: Double?
    let timepoint: Int
    let stopNote: String
}
