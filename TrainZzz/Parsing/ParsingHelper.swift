//
//  ParsingHelper.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import Foundation

class ParsingHelper {
    static func parseStopsCSV(from contents: String) -> [Stop] {
        let lines = contents.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }

        let rows = lines.dropFirst().filter { !$0.isEmpty }
        var stops: [Stop] = []
        var seenStopNames: Set<String> = []

        let stationNameRegex = try! NSRegularExpression(pattern: #"^([A-Za-z\s]+) Station, Platform \d+$"#)

        for row in rows {
            var columns = row.components(separatedBy: "\",\"")
            guard columns.count >= 10 else { continue }

            columns[0] = columns[0].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            columns[9] = columns[9].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            columns = columns.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            let stopNameFull = columns[2]
            let range = NSRange(location: 0, length: stopNameFull.utf16.count)

            if let match = stationNameRegex.firstMatch(in: stopNameFull, options: [], range: range),
               let stationRange = Range(match.range(at: 1), in: stopNameFull) {
                let trimmedStopName = "\(stopNameFull[stationRange]) Station"

                if seenStopNames.contains(trimmedStopName) {
                    continue
                }
                seenStopNames.insert(trimmedStopName)

                let stop = Stop(
                    id: columns[0],
                    stopCode: columns[1],
                    stopName: trimmedStopName,
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
        }
        return stops
    }
}
