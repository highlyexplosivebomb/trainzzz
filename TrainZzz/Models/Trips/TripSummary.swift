import Foundation

struct TripSummary: Identifiable {
    let id = UUID()
    let originName: String
    let destinationName: String
    let departureTime: String
    let arrivalTime: String
    let legs: [Trip]
}
