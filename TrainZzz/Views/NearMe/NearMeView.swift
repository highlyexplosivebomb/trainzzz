//
//  NearMeView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct NearMeView: View {
    @StateObject var stationManager = StationManager()
    @State private var isClicked = false
    @State private var selectedStation: StationData = StationData(id: "", name: "", type: "", coord: [], properties: nil)
    let initialPosition: MapCameraPosition = .userLocation(fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), distance: 7500)))

    var body: some View {
        VStack {
            Map(initialPosition: initialPosition) {
                ForEach(stationManager.stations) { station in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)) {
                        Button(action: {
                            selectedStation = station
                            isClicked = true
                        }) {
                            Image("SydneyTrainsIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
            .frame(height: UIScreen.main.bounds.height / 2.25)

            HStack {
                FilterButton(icon: "T1Icon")
                FilterButton(icon: "T2Icon")
                FilterButton(icon: "T3Icon")
                FilterButton(icon: "T4Icon")
                FilterButton(icon: "T5Icon")
                FilterButton(icon: "T6Icon")
                FilterButton(icon: "T7Icon")
                FilterButton(icon: "T8Icon")
                FilterButton(icon: "T9Icon")
            }
            .padding(.horizontal)
            
            Divider()
            
            ScrollView {
                if stationManager.stations.isEmpty {
                    Text("No nearby stations!")
                }
                
                VStack {
                    ForEach(stationManager.stations) { station in
                        let stationLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
                        let currentLocation = CLLocation(latitude: -33.8688, longitude: 151.2093)
                        let distance = stationLocation.distance(from: currentLocation)
                        
                        Station(isClicked: $isClicked, selectedStation: $selectedStation, station: station, distance: distance)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .onAppear {
            stationManager.fetchStations()
        }
        .sheet(isPresented: $isClicked) {
            StationDeparturesView(selectedStation: $selectedStation)
        }
    }
}

struct FilterButton: View {
    @State private var isActive: Bool = false
    @State private var buttonColor: Color = Color(.systemGray5)
    
    let icon: String
    
    var body: some View {
        Button(action: {
            buttonColor = isActive ? Color(.systemGray5) : .mint
            isActive = isActive ? false : true
        }) {
            Image(icon)
                .resizable()
                .scaledToFit()
        }
        .padding(3)
        .background(buttonColor)
        .cornerRadius(5)
        .foregroundColor(Color.black)
    }
}

struct Station: View {
    @Binding var isClicked: Bool
    @Binding var selectedStation: StationData
    let station: StationData
    let distance: Double
    
    var body: some View {
        HStack {
            Image("SydneyTrainsIcon")
                .resizable()
                .scaledToFit()
            
            Divider()
            Text(station.name)
            Spacer()
            if Int(distance) > 1000 {
                Text(String(format: "%.1fkm", distance / 1000))
            } else {
                Text("\(Int(distance))m")
            }
            
            Button(action: {
                selectedStation = station
                isClicked = true
            }) {
                Image(systemName: "info.circle")
            }
        }
        .frame(maxHeight: 30, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    NearMeView()
}
