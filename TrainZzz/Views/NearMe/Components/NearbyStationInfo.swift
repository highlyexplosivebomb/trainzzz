//
//  NearbyStationInfo.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct NearbyStationInfo: View {
    @StateObject var viewModel = StationDeparturesViewModel()
    @Binding var isClicked: Bool
    @Binding var selectedStation: StationData
    let station: StationData
    let distance: Double
    
    var body: some View {
        HStack {
            let stationFacilities = viewModel.getFacilitiesFromStationData(stationData: station)
            if stationFacilities.transportMode.contains("Metro") && !stationFacilities.transportMode.contains("Train") {
                Image("SydneyMetroIcon")
                    .resizable()
                    .scaledToFit()
            } else {
                Image("SydneyTrainsIcon")
                    .resizable()
                    .scaledToFit()
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
