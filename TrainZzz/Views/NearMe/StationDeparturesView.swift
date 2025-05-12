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
    @Binding var selectedStation: StationData
    @State private var selectedPickerOption = "Info"
    @State private var isExpanded = false
    @State private var isClicked = false
    @State private var selectedTrip = ""
    @State private var timer = 0
    
    var body: some View {
        VStack {
            Map(initialPosition: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedStation.latitude, longitude: selectedStation.longitude), distance: 500))) {}
            .mapStyle(.standard(showsTraffic: false))
            .frame(height: UIScreen.main.bounds.height / 12)

            HStack {
                let station = viewModel.getFacilitiesFromStationData(stationData: selectedStation)
                if station.transportMode.contains("Metro") && !station.transportMode.contains("Train") {
                    TransportModeLogo(isTrain: false, isSmall: false)
                } else {
                    TransportModeLogo(isTrain: true, isSmall: false)
                }
                
                Spacer()
                
                Text(selectedStation.name)
                    .font(.system(size: 30, weight: .bold))
            }
            .padding(.horizontal)
            
            VStack {
                Picker("Options", selection: $selectedPickerOption) {
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
                
                let station = viewModel.getFacilitiesFromStationData(stationData: selectedStation)
                switch selectedPickerOption {
                case "Departures":
                    DeparturesPickerView(isExpanded: $isExpanded, isClicked: $isClicked, selectedTrip: $selectedTrip, stationDepartures: viewModel.departures, stationName: station.name)
                case "Live":
                    LivePickerView(selectedTrip: $selectedTrip, trips: $viewModel.vehiclePositions, timer: $timer)
                default:
                    InfoPickerView(station: station)
                }
            }
            .onChange(of: isClicked) {
                selectedPickerOption = "Live"
                isClicked = false
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchFacilities()
            let tsn = Int(selectedStation.properties?.STOP_GLOBAL_ID ?? "0") ?? 0
            viewModel.fetchDepartures(tsn: tsn)
            viewModel.fetchVehiclePositions()
            startTimer()
        }
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { second in
            timer += 1
        }
    }
}
