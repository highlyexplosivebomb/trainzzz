//
//  DestinationDropdownListView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI

struct DestinationDropdownListView: View {
    var stops: [Stop]
    var onSelect: (Stop) -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(stops.prefix(10)) { stop in
                    Button(action: {
                        onSelect(stop)
                    }) {
                        HStack {
                            Text(stop.stopName)
                                .foregroundColor(.primary)
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .background(colorScheme == .dark ? Color(.secondarySystemBackground) : Color(.systemBackground))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top)
        }
        .frame(maxHeight: 300)
        .padding(.top)
    }
}
