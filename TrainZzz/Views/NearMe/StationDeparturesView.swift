//
//  StationDeparturesView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI
import MapKit

struct StationDeparturesView: View {
    @StateObject var viewModel = StationDeparturesViewModel()
    @State private var isClicked = false
    @State private var selectedOption = "Info"
    @Binding var selectedStation: StationData

    var body: some View {
        VStack() {
            Map(initialPosition: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedStation.latitude, longitude: selectedStation.longitude), distance: 500))) {}
            .mapStyle(.standard(showsTraffic: false))
            .frame(height: UIScreen.main.bounds.height / 12)

            HStack {
                let tsn = Int(selectedStation.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
                if let station = viewModel.getStationByTSN(tsn: tsn) {
                    if station.transportMode.contains("Metro") && !station.transportMode.contains("Train") {
                        Image("SydneyMetroIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .shadow(radius: 3)
                    } else {
                        Image("SydneyTrainsIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .shadow(radius: 3)
                    }
                }
                
                Spacer()
                
                Text(selectedStation.name)
                    .font(.system(size: 30, weight: .bold))
            }
            .padding(.horizontal)
            
            VStack {
                Picker("Options", selection: $selectedOption) {
                    Text("Info").tag("Info")
                    Text("Departures").tag("Departures")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                Divider()
                    .padding(.top)
                
                if selectedOption == "Info" {
                    let tsn = Int(selectedStation.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
                    if let station = viewModel.getStationByTSN(tsn: tsn) {
                        InfoView(station: station)
                    }
                } else if selectedOption == "Departures" {
                    DeparturesView()
                }
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchFacilities()
        }
    }
}

struct InfoView: View {
    let station: StationFacilities
    let facilities = [
        ("Toilets", "toilet"),
        ("Bike racks", "bicycle"),
        ("Taxi rank", "car")
    ]
    let accessibility = [
        ("Independent Access", "figure.roll"),
        ("Assisted Access", "figure.roll"),
        ("Not Accessible", "figure.roll"),
        ("PA system for announcements", "ear"),
        ("Lift", "arrow.up.arrow.down"),
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "phone")
                Text(station.phone.isEmpty ? "N/A" : station.phone)
                Spacer()
            }
            HStack {
                Image(systemName: "map")
                Text(station.address.isEmpty ? "N/A" : station.address)
                Spacer()
            }
        }
        .padding(.horizontal)
        
        Divider()
        
        VStack {
            Text("Accessibility")
                .font(.system(size: 20, weight: .bold))
            
            ForEach(accessibility, id: \.0) { accessibility, iconName in
                if station.accessibility.contains(accessibility) {
                    FacilityInfo(facility: accessibility, iconName: iconName)
                }
            }
        }
        .padding(.horizontal)
        
        Divider()
        
        VStack {
            Text("Facilities")
                .font(.system(size: 20, weight: .bold))
            
            ForEach(facilities, id: \.0) { facility, iconName in
                if station.facilities.contains(facility) {
                    FacilityInfo(facility: facility, iconName: iconName)
                }
            }
        }
        .padding(.horizontal)
        
        Divider()
    }
}

struct DeparturesView: View {
    var body: some View {
        HStack {
            Image("T1Icon")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 30)
            
            Spacer()
        }
        .padding(.horizontal)
        
        Divider()
        
        Text("No upcoming departures within the next 24 hrs.")
    }
}

struct FacilityInfo: View {
    let facility: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(facility)
            Spacer()
        }
    }
}
