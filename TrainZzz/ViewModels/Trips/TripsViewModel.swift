import Foundation
import SwiftUI

class TripsViewModel: ObservableObject {
    @Published var stops: [Stop] = []

    init() {
        stops = loadStops()
    }
    
    func loadStops() -> [Stop] {
        if let url = Bundle.main.url(forResource: "stops", withExtension: "txt"),
           let contents = try? String(contentsOf: url, encoding: .utf8) {
            let allStops = parseStopsCSV(from: contents)
            return Array(allStops.prefix(10))
        }
        return []
    }

    func parseStopsCSV(from contents: String) -> [Stop] {
        let lines = contents.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }

        let rows = lines.dropFirst().filter { !$0.isEmpty }
        var stops: [Stop] = []

        for row in rows {
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 10 else { continue }

            let stop = Stop(
                id: columns[0],
                stopCode: columns[1],
                stopName: columns[2],
                stopLat: Double(columns[3]) ?? 0.0,
                stopLon: Double(columns[4]) ?? 0.0,
                locationType: columns[5],
                parentStation: columns[6],
                wheelchairBoarding: columns[7],
                levelId: columns[8],
                platformCode: columns[9]
            )
            stops.append(stop)
        }

        return stops
    }

}
