//
//  LoadingView.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 13/5/2025.
//

import SwiftUI

struct LoadingView: View {
    var onFinish: () -> Void

    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .font(.headline)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onFinish()
            }
        }
    }
}
