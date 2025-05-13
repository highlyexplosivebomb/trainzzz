//
//  TripWrapperView.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 13/5/2025.
//

import SwiftUI

struct MainTripsView: View {
    @State private var showLoading = true

    var body: some View {
        if showLoading {
            LoadingView {
                showLoading = false
            }
        } else {
            TripsView()
        }
    }
}
