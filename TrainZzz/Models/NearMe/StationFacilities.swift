//
//  StationFacilities.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

struct StationFacilities: Codable, Identifiable {
    var id: Int
    var name: String
    var tsn: Int
    var latitude: Double
    var longitude: Double
    var phone: String
    var address: String
    var facilities: String
    var accessibility: String
    var transportMode: String
}
