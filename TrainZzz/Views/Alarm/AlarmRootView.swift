//
//  AlarmRootView.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//

import SwiftUI

struct AlarmRootView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            AlarmConfigView(navigationPath: $navigationPath)
                .navigationDestination(for: AlarmRoute.self) { route in
                    switch route {
                    case let .journey(target, radius, name):
                        AlarmJourneyView(
                            targetCoordinates: target.asCLLocationCoordinate2D,
                            targetRadius: radius,
                            destination: name,
                            navigationPath: $navigationPath
                        )
                    case .arrival:
                        AlarmArrivalView(navigationPath: $navigationPath)
                    }
                }
        }
    }
}

#Preview {
    AlarmRootView()
}
