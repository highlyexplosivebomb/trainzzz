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
    @Binding var navigationPath: NavigationPath
    
    @EnvironmentObject var locationManager: AppLocationManager
    @EnvironmentObject var audioHelper: AlarmAudioHelper
    
    @StateObject private var alarmJourneyViewModel: AlarmJourneyViewModel
    
    init(targetCoordinates: CLLocationCoordinate2D, targetRadius: CLLocationDistance, destination: String, navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
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
                Button("Terminate Alarm") {
                    navigationPath.removeLast(navigationPath.count)
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(20)
                .padding(.horizontal)
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
            print("View destroying...")
            alarmJourneyViewModel.onDestroyed()
        }
        .onReceive(locationManager.$isInRegion) { newValue in
            if newValue {
                print("navigating to arrival...")
                navigationPath.append(AlarmRoute.arrival)
            }
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    let locationManager = AppLocationManager(audioHelper: audioHelper)
    let coordinate = CLLocationCoordinate2D(latitude: -33.863596, longitude: 151.208975)
    
    AlarmJourneyView(targetCoordinates: coordinate, targetRadius: 200, destination: "Strathfield Station", navigationPath: .constant(NavigationPath()))
        .environmentObject(locationManager)
        .environmentObject(audioHelper)
}
