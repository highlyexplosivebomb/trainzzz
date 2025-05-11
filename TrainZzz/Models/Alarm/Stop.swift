//
//  Stop.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

struct Stop: Identifiable {
    let id: String
    let stopCode: String
    let stopName: String
    let stopLat: Double
    let stopLon: Double
    let locationType: String
    let parentStation: String
    let wheelchairBoarding: String
    let levelId: String
    let platformCode: String
}
