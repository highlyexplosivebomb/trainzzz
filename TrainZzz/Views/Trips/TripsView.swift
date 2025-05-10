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
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                }
            StopSelectView(selectedStop: $viewModel.toStop, viewModel: toStopVM)
                .offset(y: 250)
            StopSelectView(selectedStop: $viewModel.fromStop, viewModel: fromStopVM)
                .offset(y: 100)
        }
    }
}

#Preview {
    TripsView()
}
