//
//  StopSelectView.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 10/5/2025.
//

import SwiftUI

struct StopSelectView: View {
    @Binding var selectedStop: Stop?
    @StateObject var viewModel: StopViewModel

    @FocusState private var isFieldFocused: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Select a Stop")
                .font(.title3)
                .fontWeight(.semibold)

            TextField("Start typing...", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .focused($isFieldFocused)

            ZStack(alignment: .topLeading) {
                if !viewModel.stops.isEmpty && isFieldFocused {
                    DestinationDropdownListView(stops: viewModel.stops) { stop in
                        viewModel.searchText = stop.stopName
                        selectedStop = stop
                        isFieldFocused = false
                    }
                    .background(colorScheme == .dark ? Color(.darkGray) : Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(100)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal)
        .zIndex(99)
        .animation(.easeInOut, value: isFieldFocused)
    }
}
