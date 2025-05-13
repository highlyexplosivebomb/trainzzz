import Foundation
import SwiftUI

class TripsViewModel: ObservableObject {
    @Published var fromStop: Stop? = nil
    @Published var toStop: Stop? = nil
    @Published var allStops: [Stop] = []
    @Published var tripResults: [TripSummary] = []

    init() {
        allStops = loadStops()
    }

    func loadStops() -> [Stop] {
        guard let url = Bundle.main.url(forResource: "stops", withExtension: "txt"),
              let contents = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        return ParsingHelper.parseStopsCSV(from: contents)
    }

    func fetchTripPlan() {
        guard let from = fromStop, let to = toStop else {
            print("Missing stop selection")
            return
        }

        let baseURL = "https://api.transport.nsw.gov.au/v1/tp/trip"
        var components = URLComponents(string: baseURL)!

        //Get parameters for the api call
        let fromId = from.parentStation
        let toId = to.parentStation

        components.queryItems = [
            URLQueryItem(name: "outputFormat", value: "rapidJSON"),
            URLQueryItem(name: "coordOutputFormat", value: "EPSG:4326"),
            URLQueryItem(name: "depArrMacro", value: "dep"),
            URLQueryItem(name: "type_origin", value: "stopID"),
            URLQueryItem(name: "name_origin", value: "\(fromId)"),
            URLQueryItem(name: "type_destination", value: "stopID"),
            URLQueryItem(name: "name_destination", value: "\(toId)"),
            URLQueryItem(name: "itdDateTimeDepArr", value: "dep"),
            URLQueryItem(name: "calcNumberOfTrips", value: "5")
        ]


        guard let url = components.url else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("apikey eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI3bnVialJIeGFFVERSMTYzelhoNXpiMzlJS0ZDbE0wSnZsSFk3SW1hWDF3IiwiaWF0IjoxNzQ2OTUzMzA0fQ._JZ7-gUTvV2pZlJb212c5pdQwVI2mb_MPRLtIJ-F5D4", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching trip: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            //Populate the Trips received from api call
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                let trips = ((json?["journeys"] as? [[String: Any]]) ?? []).compactMap { journeyDict -> TripSummary? in
                    guard
                        let legs = journeyDict["legs"] as? [[String: Any]],
                        let firstLeg = legs.first,
                        let finalLeg = legs.last,
                        let origin = firstLeg["origin"] as? [String: Any],
                        let destination = finalLeg["destination"] as? [String: Any],
                        let originParent = origin["parent"] as? [String: Any],
                        let originName = originParent["disassembledName"] as? String,
                        let destParent = destination["parent"] as? [String: Any],
                        let destName = destParent["disassembledName"] as? String,
                        let depTimeStr = origin["departureTimePlanned"] as? String,
                        let arrTimeStr = destination["arrivalTimePlanned"] as? String
                    else {
                        return nil
                    }

                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime]

                    let outputFormatter = DateFormatter()
                    outputFormatter.dateFormat = "HH:mm"
                    outputFormatter.timeZone = TimeZone.current

                    let depTime = isoFormatter.date(from: depTimeStr).map { outputFormatter.string(from: $0) } ?? depTimeStr
                    let arrTime = isoFormatter.date(from: arrTimeStr).map { outputFormatter.string(from: $0) } ?? arrTimeStr
                    
                    let legList = TripsViewModel.populateLegs(legs: legs)

                    return TripSummary(
                        originName: originName,
                        destinationName: destName,
                        departureTime: depTime,
                        arrivalTime: arrTime,
                        legs: legList
                    )
                }

                DispatchQueue.main.async {
                    self.tripResults = trips
                }

            } catch {
                print("JSON parse error: \(error)")
            }

        }.resume()
    }
}

extension TripsViewModel {
    nonisolated static func populateLegs(legs: [[String: Any]]) -> [Trip] {
        var legList: [Trip] = []

        for leg in legs {
            guard let legOrigin = leg["origin"] as? [String: Any],
                  let legDestination = leg["destination"] as? [String: Any],
                  let legOriginName = legOrigin["disassembledName"] as? String,
                  let legDestinationName = legDestination["disassembledName"] as? String,
                  let legDepTimeStr = legOrigin["departureTimePlanned"] as? String,
                  let legArrTimeStr = legDestination["arrivalTimePlanned"] as? String
            else {
                continue
            }

            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime]

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            outputFormatter.timeZone = TimeZone.current

            let legDepTime = isoFormatter.date(from: legDepTimeStr).map { outputFormatter.string(from: $0) } ?? legDepTimeStr
            let arrTime = isoFormatter.date(from: legArrTimeStr).map { outputFormatter.string(from: $0) } ?? legArrTimeStr

            let newLeg = Trip(
                originName: legOriginName,
                destinationName: legDestinationName,
                departureTime: legDepTime,
                arrivalTime: arrTime
            )
            legList.append(newLeg)
        }

        return legList
    }
}

