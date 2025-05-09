//
//  LocationView.swift
//  TrainZzz
//
//  Created by Justin Wong on 8/5/2025.
//

import SwiftUI

struct LocationView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        Color(locationManager.isInRegion ? .green : .red)
            .edgesIgnoringSafeArea(.all)
            .animation(.easeInOut, value: locationManager.isInRegion)
            // .navigationBarBackButtonHidden(true) this will hide the back button
        
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
            
            Button("Request", action: {
                locationManager.request()
            })
            .font(.headline)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(30)
        }
    }
}

#Preview {
    LocationView()
}
