//
//  DeparturesResponse.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

struct DeparturesResponse: Codable {
    let stopEvents: [StopEvent]
}

struct StopEvent: Codable {
    let location: Location
    let departureTimePlanned: String
    let departureTimeEstimated: String?
    let transportation: Transportation
    let properties: Properties?
}

struct Location: Codable {
    let parent: Parent
}

struct Parent: Codable {
    let id: String
    let disassembledName: String
}

struct Transportation: Codable {
    let disassembledName: String
    let destination: Destination
}

struct Destination: Codable {
    let name: String
}

struct Properties: Codable {
    let RealtimeTripId: String
}
