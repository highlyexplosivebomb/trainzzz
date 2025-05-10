//
//  TripsView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel = TripsViewModel()

    var body: some View {
        VStack {
            Text("Stations")
            List(viewModel.stops) { stop in
                VStack(alignment: .leading) {
                    Text(stop.stopName)
                        .font(.headline)
                    Text("Code: \(stop.stopCode), Location: (\(stop.stopLat), \(stop.stopLon))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    TripsView()
}
