//
//  DepartureInfo.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct DepartureInfo: View {
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
