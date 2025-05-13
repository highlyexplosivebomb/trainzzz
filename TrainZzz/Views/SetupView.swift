//
//  SetupView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct SetupView: View {
    @ObservedObject var viewModel: SetupViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                Image("TrainZzzIcon")
                    .resizable()
                
                Text("Let's get you set up.")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                VStack {
                    Button(action: {
                        viewModel.request()
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
                        viewModel.startButtonClick()
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
                    Text("Location permissions must be granted for app to function. If this was denied, go into settings and change it to always.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 1.0, green: 0.0, blue: 0.1))
                        .opacity(viewModel.permissionNotGranted ? 1 : 0)
                }

                Spacer()
            }
            .background(Color(red: 245 / 255, green: 236 / 255, blue: 227 / 255))
            .onAppear {
                _ = viewModel.checkForExistingPermissions()
            }
        }
    }
}


#Preview {
    let audioHelper = AlarmAudioHelper()
    let locationManager = AppLocationManager(audioHelper: audioHelper)
    let viewModel = SetupViewModel(locationManager: locationManager)

    return SetupView(viewModel: viewModel)
        .environmentObject(locationManager)
        .environmentObject(audioHelper)
}
