//
//  AlarmView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct AlarmView: View {
    @StateObject var stationManager = StationManager()
    
    var body: some View {
        SwiftUI.NavigationView {
            VStack {
                List {
                    ForEach(stationManager.stations) { station in
                        VStack(alignment: .leading) {
                            Text(station.name)
                                .font(.headline)
                            Text("Lat: \(station.latitude), Lon: \(station.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .navigationTitle("Train Stations")
                
                NavigationLink(destination: LocationView()) {
                    Text("Start Location View")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding()
            }
        }
        .onAppear {
            stationManager.fetchStations()
        }
    }
}

#Preview {
    AlarmView()
}
