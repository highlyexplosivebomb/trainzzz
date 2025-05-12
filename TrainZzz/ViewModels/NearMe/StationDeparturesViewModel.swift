//
//  StationDeparturesViewModel.swift
//  TrainZzz
//
//  Created by John Ly on 11/5/2025.
//

import Foundation
import SwiftProtobuf

class StationDeparturesViewModel: ObservableObject {
    @Published var facilities: [StationFacilities] = []
    @Published var departures: [StopEvent] = []
    @Published var vehiclePositions: [TransitRealtime_VehiclePosition] = []

    func fetchFacilities() {
        // It isn't possible to request this data from an API. TFNSW has deprecated the API, with the alternative being to use a CURL request. However, TFNSW has limited it to 5 requests per day, meaning that this functionality would break after 5 uses. Whilst we could cache it in some way, this would not carry across to other devices; hence the use of a local file.
        do {
            guard let url = Bundle.main.url(forResource: "stationfacilities", withExtension: "json") else {
                exit(1)
            }
            
            let data = try Data(contentsOf: url)
            
            // This is a strange data type. If you look at stationfacilities.json, you'll notice that all of these values are stored in a single array, so it's not decodable into a type. Hence, the manual mapping.
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let records = json?["records"] as? [[Any]] ?? []
            var structuredFacilities: [StationFacilities] = []

            for row in records {
                let record = StationFacilities(
                    id: row[0] as? Int ?? 0,
                    name: row[1] as? String ?? "",
                    tsn: row[2] as? Int ?? 0,
                    latitude: row[3] as? Double ?? 0.0,
                    longitude: row[4] as? Double ?? 0.0,
                    phone: row[6] as? String ?? "",
                    address: row[7] as? String ?? "",
                    facilities: row[8] as? String ?? "",
                    accessibility: row[9] as? String ?? "",
                    transportMode: row[10] as? String ?? "",
                )

                structuredFacilities.append(record)
            }

            DispatchQueue.main.async {
                self.facilities = structuredFacilities
            }
        } catch {
            exit(1)
        }
    }
    
    func fetchDepartures(tsn: Int) {
        let apiUrl = "https://api.transport.nsw.gov.au/v1/tp/departure_mon?outputFormat=rapidJSON&coordOutputFormat=EPSG%3A4326&mode=direct&type_dm=stop&name_dm=\(tsn)&departureMonitorMacro=true&excludedMeans=checkbox&exclMOT_4=1&exclMOT_5=1&exclMOT_7=1&exclMOT_9=1&exclMOT_11=1&TfNSWDM=true&version=10.2.1.42"
        
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("apikey eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlNHVLS3hQLTNnWXhqVmFHejFtcE5yNjQxZEtEdE11YjFGUVM5bV9BU3FVIiwiaWF0IjoxNzQ2NjE5NzQyfQ.ocO_ouhUydWSFBZ2Uz5aNt4nH2VUtwQ9WjCPZKVOETI", forHTTPHeaderField: "Authorization")

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(DeparturesResponse.self, from: data)

                DispatchQueue.main.async {
                    self.departures = decoded.stopEvents
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func fetchVehiclePositions() {
        let apiUrl = "https://api.transport.nsw.gov.au/v2/gtfs/vehiclepos/sydneytrains"
        
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/x-protobuf", forHTTPHeaderField: "Accept")
        request.setValue("apikey eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJlNHVLS3hQLTNnWXhqVmFHejFtcE5yNjQxZEtEdE11YjFGUVM5bV9BU3FVIiwiaWF0IjoxNzQ2NjE5NzQyfQ.ocO_ouhUydWSFBZ2Uz5aNt4nH2VUtwQ9WjCPZKVOETI", forHTTPHeaderField: "Authorization")

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let feedMessage = try TransitRealtime_FeedMessage(serializedBytes: data)

                DispatchQueue.main.async {
                    self.vehiclePositions = feedMessage.entity.compactMap { $0.hasVehicle ? $0.vehicle : nil }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        
        task.resume()
    }
    
    func getStationByTSN(tsn: Int) -> StationFacilities? {
        return facilities.first { $0.tsn == tsn }
    }
    
    func getFacilitiesFromStationData(stationData: StationData) -> StationFacilities {
        let tsn = Int(stationData.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
        if let station = getStationByTSN(tsn: tsn) {
            return station
        }
        
        return StationFacilities(id: 0, name: "", tsn: 0, latitude: 0.0, longitude: 0.0, phone: "", address: "", facilities: "", accessibility: "", transportMode: "")
    }
}
