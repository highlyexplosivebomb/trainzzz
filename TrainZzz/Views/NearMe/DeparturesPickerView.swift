//
//  DeparturesPickerView.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct DeparturesPickerView: View {
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
                    DepartureInfo(isExpanded: $isExpanded, isClicked: $isClicked, selectedTrip: $selectedTrip, selectedDeparture: departure, stationName: stationName)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}
