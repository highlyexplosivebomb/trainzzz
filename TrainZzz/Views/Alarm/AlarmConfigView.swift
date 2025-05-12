//
//  AlarmConfigView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI

struct AlarmConfigView: View {
    @StateObject private var viewModel = AlarmConfigViewModel()
    @StateObject private var destinationViewModel: StopViewModel

    init() {
        let alarmConfigVM = AlarmConfigViewModel()
        _viewModel = StateObject(wrappedValue: alarmConfigVM)
        _destinationViewModel = StateObject(wrappedValue: StopViewModel(allStops: alarmConfigVM.allStops))
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
            StopSelectView(selectedStop: $viewModel.destination, viewModel: destinationViewModel)
                .offset(y: 250)
        }
    }
}

#Preview {
    AlarmConfigView()
}
