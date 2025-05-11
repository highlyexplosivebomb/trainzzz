//
//  StopSelectView.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 10/5/2025.
//

import Combine
import SwiftUI

struct StopSelectView: View {
    @Binding var selectedStop: Stop?
    @StateObject var viewModel: StopViewModel

    @FocusState private var isFieldFocused: Bool
    @State private var isDropdownVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search for a Station")
                .font(.headline)
                .padding(.horizontal)

            TextField("Start typing...", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .focused($isFieldFocused)

            Spacer()
        }
        .animation(.easeInOut, value: isFieldFocused)
        .overlay(alignment: .top) {
            if !viewModel.stops.isEmpty && isFieldFocused {
                StopDropdownList(stops: viewModel.stops) { stop in
                    selectedStop = stop
                    viewModel.searchText = stop.stopName
                    isFieldFocused = false
                }
            }
        }
    }
}
