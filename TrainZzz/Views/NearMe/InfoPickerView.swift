//
//  InfoPickerView.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct InfoPickerView: View {
    let station: StationFacilities
    let facilities = [
        ("Opal card top up", "creditcard"),
        ("Toilets", "toilet"),
        ("Bike racks", "bicycle"),
        ("Taxi rank", "car"),
        ("Free mobile phone charging", "power")
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
