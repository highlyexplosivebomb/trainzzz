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

            if let stop = selectedStop {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Selected Station:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(stop.stopName)
                        .font(.body)
                        .bold()
                }
                .padding(.horizontal)
                .padding(.top)
            }

            Spacer()
        }
        .animation(.easeInOut, value: isFieldFocused)
        .overlay(alignment: .top) {
            if !viewModel.stops.isEmpty && isFieldFocused {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.stops.prefix(10)) { stop in
                            Button(action: {
                                selectedStop = stop
                                viewModel.searchText = stop.stopName
                                isFieldFocused = false
                            }) {
                                HStack {
                                    Text(stop.stopName)
                                        .foregroundColor(.primary)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal)
                                    Spacer()
                                }
                                .background(Color.white)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                .frame(maxHeight: 300)
                .padding(.top, 60)
            }
        }
    }
}
