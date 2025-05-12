//
//  Trip.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 11/5/2025.
//

import Foundation

struct TripSummary: Identifiable {
    let id = UUID()
    let originName: String
    let destinationName: String
    let departureTime: String
    let arrivalTime: String
}
