//
//  SetupView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct SetupView: View {
    @State private var isSetup: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()

                Text("Let's get you set up.")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Button(action: {
                    isSetup = true
                }) {
                    Text("Start")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .padding(.horizontal, 80)
                }

                Spacer()
            }
            .navigationDestination(isPresented: $isSetup) {
                NavigationView().navigationBarBackButtonHidden(true) // Replace with your real destination view
            }
        }
    }
}


#Preview {
    SetupView()
}
