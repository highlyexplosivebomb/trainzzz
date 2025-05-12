//
//  LocationView.swift
//  TrainZzz
//
//  Created by Justin Wong on 8/5/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationView: View {
    @EnvironmentObject var locationManager: AppLocationManager
    private let targetCoordinates: CLLocationCoordinate2D
    private let targetRadius: CLLocationDistance
    private let heading: String
    
    init(targetCoordinates: CLLocationCoordinate2D, targetRadius: CLLocationDistance, destination: String) {
        self.targetCoordinates = targetCoordinates
        self.targetRadius = targetRadius
        self.heading = "My Current Trip to \(destination)"
    }
    
    var body: some View {
        VStack {
            Color(locationManager.isInRegion ? .green : .red)
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: locationManager.isInRegion)
                .navigationBarBackButtonHidden(true) // this will hide the back button
            
            VStack(alignment: .leading, spacing: 15) {
                Text(heading)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            MapView(coordinate: locationManager.getCurrentLocation()!)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Nearest Station:")
                    .font(.title2)
                    .bold()
                
                Text("Strathfield Station")
                    .font(.title2)
                
                Text("Distance to Destination:")
                    .font(.title2)
                    .bold()
                
                Text("500m")
                    .font(.title2)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
            .padding(.vertical)
        }
        .onAppear {
            if locationManager.authorisationStatus == .authorizedAlways {
                locationManager.startMonitoringRegion(targetCoordinates: self.targetCoordinates, targetRadius: self.targetRadius)
            } else {
                locationManager.request()
            }
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    let locationManager = AppLocationManager(audioHelper: audioHelper)
    let coordinate = CLLocationCoordinate2D(latitude: -33.863596, longitude: 151.208975)
    
    LocationView(targetCoordinates: coordinate, targetRadius: 200, destination: "Strathfield Station")
        .environmentObject(locationManager)
        .environmentObject(audioHelper)
}
