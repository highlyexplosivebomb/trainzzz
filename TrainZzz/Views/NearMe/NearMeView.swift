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
    @StateObject var viewModel = StationDeparturesViewModel()
    @State private var isClicked = false
    @State private var selectedStation: StationData = StationData(id: "", name: "", type: "", coord: [], properties: nil)
    @State private var filters: [String] = []
    let initialPosition: MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), distance: 7500))

    var body: some View {
        VStack {
            Map(initialPosition: initialPosition) {
                ForEach(stationManager.stations) { station in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)) {
                        Button(action: {
                            selectedStation = station
                            isClicked = true
                        }) {
                            let tsn = Int(station.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
                            if let station = viewModel.getStationByTSN(tsn: tsn) {
                                if station.transportMode.contains("Metro") && !station.transportMode.contains("Train") {
                                    Image("SydneyMetroIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 3)
                                } else {
                                    Image("SydneyTrainsIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 3)
                                }
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
            .frame(height: UIScreen.main.bounds.height / 2.25)

            HStack {
                FilterButton(filters: $filters, icon: "toilet", text: "Toilets", filter: "Toilets")
                FilterButton(filters: $filters, icon: "figure.roll", text: "Accessible", filter: "Independent Access")
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
                        
                        let tsn = Int(station.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
                        if let facilities = viewModel.getStationByTSN(tsn: tsn) {
                            let matchedFilters = filters.filter { filter in
                                facilities.facilities.contains(filter) || facilities.accessibility.contains(filter)
                            }
                            if matchedFilters.count == filters.count {
                                Station(isClicked: $isClicked, selectedStation: $selectedStation, station: station, distance: distance)
                            }
                        }

                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .onAppear {
            stationManager.fetchStations()
            viewModel.fetchFacilities()
        }
        .sheet(isPresented: $isClicked) {
            StationDeparturesView(selectedStation: $selectedStation)
        }
    }
}

struct FilterButton: View {
    @State private var isActive: Bool = false
    @State private var buttonColor: Color = Color(.systemGray5)
    @Binding var filters: [String]
    
    let icon: String
    let text: String
    let filter: String
    
    var body: some View {
        Button(action: {
            buttonColor = isActive ? Color(.systemGray5) : .mint
            isActive = isActive ? false : true
            
            if isActive {
                filters.append(filter)
            } else {
                filters.removeAll { $0 == filter }
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    
                Text(text)
            }.frame(maxHeight: 25, alignment: .leading)
        }
        .padding(6)
        .background(buttonColor)
        .cornerRadius(5)
        .foregroundColor(Color.black)
    }
}

struct Station: View {
    @StateObject var viewModel = StationDeparturesViewModel()
    @Binding var isClicked: Bool
    @Binding var selectedStation: StationData
    let station: StationData
    let distance: Double
    
    var body: some View {
        HStack {
            // There's a lot of yucky code right now tbh. But seeing a Sydney Trains icon on a Sydney Metro station is worse. I'll clean this up soon :D
            let tsn = Int(station.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
            if let station = viewModel.getStationByTSN(tsn: tsn) {
                if station.transportMode.contains("Metro") && !station.transportMode.contains("Train") {
                    Image("SydneyMetroIcon")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image("SydneyTrainsIcon")
                        .resizable()
                        .scaledToFit()
                }
            }
            
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
        .onAppear() {
            viewModel.fetchFacilities()
        }
        .frame(maxHeight: 30, alignment: .leading)
        .padding(.horizontal)
    }
}

#Preview {
    NearMeView()
}
