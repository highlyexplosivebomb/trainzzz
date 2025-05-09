//
//  SetupView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct SetupView: View {
    @State private var isSetup: Bool = false
    @StateObject private var locationManager = SetupLocationManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                Image("TrainZzzIcon")
                    .resizable()
                
                Text("Let's get you set up.")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                VStack {
                    Button(action: {
                        locationManager.request()
                    }) {
                        Text("Request Permissions")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                            .padding(.horizontal, 80)
                    }
                    
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
                    .padding(.bottom)
                }

                Spacer()
            }
            .background(Color(red: 245 / 255, green: 236 / 255, blue: 227 / 255))
            .onAppear {
                if(locationManager.authorisationStatus == .authorizedWhenInUse || locationManager.authorisationStatus == .authorizedAlways){
                    isSetup = true
                }
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
