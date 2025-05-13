//
//  StationManager.swift
//  TrainZzz
//
//  Created by Justin Wong on 7/5/2025.
//

import Foundation
import Combine
import CoreLocation

class StationManager: ObservableObject {
    @Published var stations: [StationData] = []
    
    // This method will call TFNSW's Coordinate Request, with params specifically looking for transit stops (BUS_POINT's). We then filter out all but the train and metro stations, and add them to a list belonging to this class.
    func fetchStations(currentLocation: CLLocationCoordinate2D, radiusInMetres: Int) {
        let apiUrl = "https://api.transport.nsw.gov.au/v1/tp/coord?outputFormat=rapidJSON&coord=\(currentLocation.longitude)%3A\(currentLocation.latitude)%3AEPSG%3A4326&coordOutputFormat=EPSG:4326&inclFilter=1&type_1=BUS_POINT&radius_1=\(radiusInMetres)&PoisOnMapMacro=false&version=10.2.1.42"

        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        // These add extra headers required for the API call
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
                let filteredStations = self.filterAndRemoveDuplicateStations(from: decoded.locations)
                
                let current = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                
                // This sorts them based on how close they are to your current location (closest is at the top of the list)
                let sortedStations = filteredStations.sorted {
                    let station1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                    let station2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                    return station1.distance(from: current) < station2.distance(from: current)
                }
                
                // This ensures that stations gets updated
                DispatchQueue.main.async {
                    self.stations = sortedStations
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }

        task.resume()
    }

    private func filterAndRemoveDuplicateStations(from locations: [StationData]) -> [StationData] {
        let stationNameRegex = #"^[A-Za-z\s]+ Station$"# // All train stations have a name which matches this regex
        var stationMap: [String: StationData] = [:]

        for location in locations {
            let name = location.name

            guard location.type == "platform", // If the location type is a platform, it belongs to a train station
                  name.range(of: stationNameRegex, options: .regularExpression) != nil else {
                continue
            }
            
            // This ensures you don't get duplicates as there will be an entry for each platform in a station from the API. e.g. Central Station has 26 platforms, therefore will have 26 entries, which need to be filtered down and consolidated.
            if stationMap[name] == nil {
                stationMap[name] = location
            }
        }

        return Array(stationMap.values)
    }
}
