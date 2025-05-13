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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Route from")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(trip.originName) → \(trip.destinationName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    HStack {
                        Label("Departs", systemImage: "arrow.up.circle")
                        Text(trip.departureTime)
                    }
                    .foregroundColor(.blue)

                    HStack {
                        Label("Arrives", systemImage: "arrow.down.circle")
                        Text(trip.arrivalTime)
                    }
                    .foregroundColor(.green)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                VStack(alignment: .leading, spacing: 16) {
                    Text("Trip Legs")
                        .font(.title3)
                        .fontWeight(.semibold)
                    ForEach(trip.legs, id: \.self) { leg in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("• \(leg.originName) → \(leg.destinationName)")
                                .font(.headline)
                            Text("\(leg.departureTime) - \(leg.arrivalTime)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                        Divider()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Route Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RouteView(trip: TripSummary(originName: "Origin Name", destinationName: "Destination Name", departureTime: "", arrivalTime: "", legs: []))
}
