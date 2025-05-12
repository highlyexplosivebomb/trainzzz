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
        ZStack {
            //Order these by back to front
            List(viewModel.tripResults) { trip in
                VStack(alignment: .leading) {
                    Text("\(trip.originName) → \(trip.destinationName)")
                        .font(.headline)
                    Text("Departs: \(trip.departureTime)")
                    Text("Arrives: \(trip.arrivalTime)")
                }
            }
            .listStyle(PlainListStyle())
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .offset(y: 150)
            .frame(height: UIScreen.main.bounds.height - 425)
            
            Button("Find Trips") {
                viewModel.fetchTripPlan()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .offset(y: -125)
            
            StopSelectView(selectedStop: $viewModel.toStop, viewModel: toStopVM)
                .offset(y: 150)
            StopSelectView(selectedStop: $viewModel.fromStop, viewModel: fromStopVM)
                .offset(y: 50)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    TripsView()
}
