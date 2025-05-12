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
    @State private var selectedOption = "Info"
    @Binding var selectedStation: StationData
    @State private var isExpanded = false
    @State private var isClicked = false
    @State private var selectedTrip = ""

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
                    
                    if isExpanded {
                        Text("Live").tag("Live")
                    }
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
                    let tsn = Int(selectedStation.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
                    if let station = viewModel.getStationByTSN(tsn: tsn) {
                        DeparturesView(isExpanded: $isExpanded, isClicked: $isClicked, selectedTrip: $selectedTrip, stationDepartures: viewModel.departures, stationName: station.name)
                    }
                } else if selectedOption == "Live" {
                    Live(selectedTrip: $selectedTrip)
                }
            }.onChange(of: isClicked) {
                selectedOption = "Live"
                isClicked = false
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchFacilities()
            let tsn = Int(selectedStation.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
            viewModel.fetchDepartures(tsn: tsn)
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
    @Binding var isExpanded: Bool
    @Binding var isClicked: Bool
    @Binding var selectedTrip: String
    let stationDepartures: [StopEvent]
    let stationName: String
    var body: some View {
        ScrollView {
            if stationDepartures.isEmpty {
                Text("No departures today!")
            }
            
            VStack {
                ForEach(stationDepartures, id: \.properties?.RealtimeTripId) { departure in
                    Departure(isExpanded: $isExpanded, isClicked: $isClicked, selectedTrip: $selectedTrip, selectedDeparture: departure, stationName: stationName)
                }
            }
            .frame(maxWidth: .infinity)
        }
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

struct Departure: View {
    @Binding var isExpanded: Bool
    @Binding var isClicked: Bool
    @Binding var selectedTrip: String
    let selectedDeparture: StopEvent
    let stationName: String
    
    var body: some View {
        VStack {
            HStack {
                Text(ISOToAEST(isoString: selectedDeparture.departureTimePlanned))
                    .font(.system(size: 30, weight: .bold))
                Spacer()
                Image("\(selectedDeparture.transportation.disassembledName)Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .shadow(radius: 3)
            }
            HStack {
                Text(selectedDeparture.transportation.destination.name)
                Spacer()
                Text(selectedDeparture.location.parent.disassembledName.replacingOccurrences(of: "\(stationName), ", with: ""))
            }
            Divider()
            Button(action: {
                isExpanded = true
                isClicked = true
                selectedTrip = selectedDeparture.properties?.RealtimeTripId ?? ""
            }) {
                Text("View Live!")
            }
        }
        .padding(.horizontal)
    }
    
    func ISOToAEST(isoString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoString) else {
            return ""
        }

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Australia/Sydney")
        formatter.dateFormat = "h:mm a"
        
        return formatter.string(from: date)
    }
}

struct Live : View {
    @Binding var selectedTrip: String
    
    var body: some View {
        Text(selectedTrip)
    }
}
