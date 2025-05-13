//
//  LocationView.swift
//  TrainZzz
//
//  Created by Justin Wong on 8/5/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct AlarmJourneyView: View {
    @EnvironmentObject var locationManager: AppLocationManager
    @EnvironmentObject var audioHelper: AlarmAudioHelper
    
    @StateObject private var alarmJourneyViewModel: AlarmJourneyViewModel
    
    init(targetCoordinates: CLLocationCoordinate2D, targetRadius: CLLocationDistance, destination: String) {
        _alarmJourneyViewModel = StateObject(wrappedValue: AlarmJourneyViewModel(
            currentLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            targetCoordinates: targetCoordinates,
            targetRadius: targetRadius,
            destinationName: destination
        ))
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(alarmJourneyViewModel.heading)
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                    .padding(.horizontal)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            MapView(coordinate: alarmJourneyViewModel.currentLocation)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Nearest Station")
                    .font(.title2)
                    .bold()
                
                Text(alarmJourneyViewModel.nearestStation)
                    .font(.title2)
                
                Text("Distance to Destination")
                    .font(.title2)
                    .bold()
                
                Text(alarmJourneyViewModel.distanceFromDestination)
                    .font(.title2)
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button("Terminate Alarm", action: {
                    alarmJourneyViewModel.stopRegionMonitoring()
                })
                .font(.headline)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(30)
            
                Button("Stop Alarm", action: {
                    audioHelper.stopAlarmSound()
                })
                .font(.headline)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(30)
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if locationManager.authorisationStatus == .authorizedAlways {
                locationManager.startMonitoringRegion(targetCoordinates: alarmJourneyViewModel.targetCoordinates, targetRadius: alarmJourneyViewModel.targetRadius)
                alarmJourneyViewModel.getAndSetLocationManager(manager: locationManager)
            } else {
                locationManager.request()
            }
        }
        .onDisappear {
            alarmJourneyViewModel.onDestroyed()
            audioHelper.stopAlarmSound()
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    let locationManager = AppLocationManager(audioHelper: audioHelper)
    let coordinate = CLLocationCoordinate2D(latitude: -33.863596, longitude: 151.208975)
    
    AlarmJourneyView(targetCoordinates: coordinate, targetRadius: 200, destination: "Strathfield Station")
        .environmentObject(locationManager)
        .environmentObject(audioHelper)
}
