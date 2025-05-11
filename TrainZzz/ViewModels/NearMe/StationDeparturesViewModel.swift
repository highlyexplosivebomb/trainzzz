//
//  StationDeparturesViewModel.swift
//  TrainZzz
//
//  Created by John Ly on 11/5/2025.
//

import Foundation

class StationDeparturesViewModel: ObservableObject {
    @Published var facilities: [StationFacilities] = []
    
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
    
    func getStationByTSN(tsn: Int) -> StationFacilities? {
        return facilities.first { $0.tsn == tsn }
    }
}

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
