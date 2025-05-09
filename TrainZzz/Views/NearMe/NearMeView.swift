//
//  NearMeView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI
import MapKit

struct NearMeView: View {
    @StateObject var stationManager = StationManager()
    @State var isClicked = false
    let initialPosition: MapCameraPosition = .userLocation(fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), distance: 7500)))

    var body: some View {
        VStack() {
            Map(initialPosition: initialPosition) {
                ForEach(stationManager.stations) { station in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)) {
                        Button(action: {
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
                VStack {
                    ForEach(stationManager.stations) { station in
                        Station(name: station.name)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
        }
        .onAppear {
            stationManager.fetchStations()
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
    let name: String
    
    var body: some View {
        HStack {
            Image("SydneyTrainsIcon")
                .resizable()
                .scaledToFit()
            
            Divider()
            Text("500m")
            Divider()
            Text(name)
            Spacer()
            
            Button(action: {
                print("I don't go anywhere yet...")
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
