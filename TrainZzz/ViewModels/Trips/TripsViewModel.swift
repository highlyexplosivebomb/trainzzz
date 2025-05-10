import Foundation
import SwiftUI

class TripsViewModel: ObservableObject {
    @Published var fromStop: Stop? = nil
    @Published var toStop: Stop? = nil
    @Published var allStops: [Stop] = []
    
    init()
    {
        allStops = loadStops()
    }
    
    func loadStops() -> [Stop] {
        if let url = Bundle.main.url(forResource: "stops", withExtension: "txt"),
           let contents = try? String(contentsOf: url, encoding: .utf8) {
            return parseStopsCSV(from: contents)
        }
        return []
    }

    func parseStopsCSV(from contents: String) -> [Stop] {
        let lines = contents.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }

        let rows = lines.dropFirst().filter { !$0.isEmpty }
        var stops: [Stop] = []

        let stationNameRegex = try! NSRegularExpression(pattern: #"^[A-Za-z\s]+ Station$"#)

        for row in rows {
            var columns = row.components(separatedBy: "\",\"")
            guard columns.count >= 10 else { continue }

            // Fix first and last column quotes
            columns[0] = columns[0].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            columns[9] = columns[9].trimmingCharacters(in: CharacterSet(charactersIn: "\""))

            // Also trim others just in case (optional)
            columns = columns.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            let stopName = columns[2]

            // Match with regex
            let range = NSRange(location: 0, length: stopName.utf16.count)
            if stationNameRegex.firstMatch(in: stopName, options: [], range: range) == nil {
                continue
            }

            let stop = Stop(
                id: columns[0],
                stopCode: columns[1],
                stopName: stopName,
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
