//
//  TripsView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct TripsView: View {
    @StateObject private var viewModel = TripsViewModel()
    @StateObject private var fromStopVM: StopViewModel
    @StateObject private var toStopVM: StopViewModel

    init() {
        let tripsVM = TripsViewModel()
        _viewModel = StateObject(wrappedValue: tripsVM)
        _fromStopVM = StateObject(wrappedValue: StopViewModel(allStops: tripsVM.allStops))
        _toStopVM = StateObject(wrappedValue: StopViewModel(allStops: tripsVM.allStops))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    StopSelectView(selectedStop: $viewModel.fromStop, viewModel: fromStopVM)
                    StopSelectView(selectedStop: $viewModel.toStop, viewModel: toStopVM)

                    Button("Find Trips") {
                        viewModel.fetchTripPlan()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    if !viewModel.tripResults.isEmpty {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(viewModel.tripResults, id: \.self) { trip in
                                    NavigationLink(destination: RouteView(trip: trip)) {
                                        VStack(alignment: .leading) {
                                            Text("\(trip.originName) → \(trip.destinationName)")
                                                .font(.headline)
                                            Text("\(trip.departureTime) - \(trip.arrivalTime)")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    Divider()
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.vertical)
                .ignoresSafeArea(.keyboard)
            }

        }
    }
}

#Preview {
    TripsView()
}
