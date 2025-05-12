//
//  StationManager.swift
//  TrainZzz
//
//  Created by Justin Wong on 7/5/2025.
//

import Foundation
import Combine

class StationManager: ObservableObject {
    @Published var stations: [StationData] = []
    
    private let stationUrl = "https://api.transport.nsw.gov.au/v1/tp/coord?outputFormat=rapidJSON&coord=151.206290%3A-33.884080%3AEPSG%3A4326&coordOutputFormat=EPSG%3A4326&inclFilter=1&type_1=BUS_POINT&radius_1=3000&PoisOnMapMacro=false&version=10.2.1.42"

    func fetchStations() {
        guard let url = URL(string: stationUrl) else {
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
                let decoded = try JSONDecoder().decode(StationResponse.self, from: data)
                let filteredStations = self.filterAndDeduplicateStations(from: decoded.locations)

                DispatchQueue.main.async {
                    self.stations = filteredStations
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }

        task.resume()
    }

    private func filterAndDeduplicateStations(from locations: [StationData]) -> [StationData] {
        let stationNameRegex = #"^[A-Za-z\s]+ Station$"#
        var stationMap: [String: StationData] = [:]

        for location in locations {
            let name = location.name

            guard location.type == "platform",
                  name.range(of: stationNameRegex, options: .regularExpression) != nil else {
                continue
            }

            if stationMap[name] == nil {
                stationMap[name] = location
            }
        }

        return Array(stationMap.values)
    }
}
