//
//  StationData.swift
//  TrainZzz
//
//  Created by Justin Wong on 7/5/2025.
//

import Foundation

struct StationData: Decodable, Identifiable {
    let id: String
    let name: String
    let type: String
    let coord: [Double]
    let properties: StationProperties?

    var globalId: String {
        properties?.STOP_GLOBAL_ID ?? UUID().uuidString
    }

    var latitude: Double {
        coord.first ?? 0.0
    }

    var longitude: Double {
        coord.count > 1 ? coord[1] : 0.0
    }
}

struct StationProperties: Decodable {
    let STOP_GLOBAL_ID: String
}

