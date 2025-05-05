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
            VStack {
                Spacer()
                Text("Let's set you up.")
                    .font(.largeTitle)
                    .fontWeight(Font.Weight.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Start") {
                    isSetup = true
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(35)
            .navigationDestination(isPresented: $isSetup) {
                NavigationView().navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SetupView()
}
