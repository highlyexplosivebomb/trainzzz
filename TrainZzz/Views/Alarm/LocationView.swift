//
//  LocationView.swift
//  TrainZzz
//
//  Created by Justin Wong on 8/5/2025.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject var locationManager: AppLocationManager
    
    var body: some View {
        VStack {
            Color(locationManager.isInRegion ? .green : .red)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: locationManager.isInRegion)
                .navigationBarBackButtonHidden(true) // this will hide the back button
        
            Text("Red means not there, green means there")
                .padding()
        
            HStack {
                Button("Start Alarm", action: {
                    locationManager.playAlarmSound()
                })
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
            
                Button("Stop Alarm", action: {
                    locationManager.stopAlarmSound()
                })
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
            }
            .padding(.bottom)
        }
        .onAppear {
            if locationManager.authorisationStatus == .authorizedAlways {
                print("Already authorized — starting region monitoring")
                locationManager.startMonitoringRegion()
            } else {
                print("Not authorized yet — requesting permission")
                locationManager.request()
            }
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    let locationManager = AppLocationManager(audioHelper: audioHelper)
    
    LocationView()
        .environmentObject(locationManager)
        .environmentObject(audioHelper)
}
