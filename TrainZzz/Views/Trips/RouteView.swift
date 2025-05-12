//
//  RouteSelectView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

import SwiftUI

struct RouteView: View {
    let trip: TripSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Route from \(trip.originName) to \(trip.destinationName)")
                .font(.title2)
                .bold()

            Text("Departure: \(trip.departureTime)")
            Text("Arrival: \(trip.arrivalTime)")

            Divider()

            Text("Legs:")
                .font(.headline)

            ForEach(trip.legs, id: \.self) { leg in
                VStack(alignment: .leading) {
                    Text("• \(leg.originName) → \(leg.destinationName)")
                    Text("  \(leg.departureTime) - \(leg.arrivalTime)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Route Details")
    }
}

#Preview {
    RouteView(trip: TripSummary(originName: "Origin Name", destinationName: "Destination Name", departureTime: "", arrivalTime: "", legs: []))
}
