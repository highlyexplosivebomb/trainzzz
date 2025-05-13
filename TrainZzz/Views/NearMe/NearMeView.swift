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
    @EnvironmentObject var locationManager: AppLocationManager
    @StateObject var stationManager = StationManager()
    @StateObject var viewModel = StationDeparturesViewModel()
    @State private var isClicked = false
    @State private var selectedStation: StationData = StationData(id: "", name: "", type: "", coord: [], properties: nil)
    @State private var filters: [String] = []
    @State private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
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
                            let stationFacilites = viewModel.getFacilitiesFromStationData(stationData: station)
                            if stationFacilites.transportMode.contains("Metro") && !stationFacilites.transportMode.contains("Train") {
                                TransportModeLogo(isTrain: false, isSmall: true)
                            } else {
                                TransportModeLogo(isTrain: true, isSmall: true)
                            }
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll, showsTraffic: false))
            .frame(height: UIScreen.main.bounds.height / 2.25)

            HStack {
                FilterButton(filters: $filters, icon: "figure.roll", text: "Accessible", filter: "Independent Access")
                FilterButton(filters: $filters, icon: "toilet", text: "Toilets", filter: "Toilets")
                Spacer()
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
                        let currentLocationAsCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                        let distance = stationLocation.distance(from: currentLocationAsCLLocation)
                        
                        let stationFacilities = viewModel.getFacilitiesFromStationData(stationData: station)
                        let matchedFilters = filters.filter { filter in
                            stationFacilities.facilities.contains(filter) || stationFacilities.accessibility.contains(filter)
                        }
                        
                        if matchedFilters.count == filters.count {
                            NearbyStationInfo(isClicked: $isClicked, selectedStation: $selectedStation, station: station, distance: distance)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .onAppear {
            if let locationPing = locationManager.getCurrentLocation() {
                currentLocation = locationPing
                stationManager.fetchStations(currentLocation: currentLocation, radiusInMetres: 3000) // anything higher than this can cause issues
                viewModel.fetchFacilities()
            } else {
                print("Cannot get current location.")
            }
        }
        .sheet(isPresented: $isClicked) {
            StationDeparturesView(selectedStation: $selectedStation)
        }
    }
}
