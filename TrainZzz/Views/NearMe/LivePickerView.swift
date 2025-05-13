//
//  LivePickerView.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI
import MapKit

struct LivePickerView: View {
    @Binding var selectedTrip: String
    @Binding var trips: [TransitRealtime_VehiclePosition]
    @Binding var timer: Int
    @State private var activeTrip: TransitRealtime_VehiclePosition?
    @State private var cameraPosition: MapCameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093), distance: 1000))
    @State private var isVisible: Bool = true
    
    var body: some View {
        VStack {
            if let activeTrip = activeTrip {
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: Double(activeTrip.position.latitude), longitude: Double(activeTrip.position.longitude))) {
                        TransportModeLogo(isTrain: true, isSmall: true)
                    }
                }
                
                Text("🔴  Live, monitoring for updates")
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeInOut(duration: 0.75), value: isVisible)
            } else {
                Text("No real-time data available for this trip.")
            }
        }
        .onAppear() {
            updateActiveTrip()
        }
        .onChange(of: timer) {
            isVisible.toggle()
            if (timer % 10 == 0) {
                updateActiveTrip()
            }
        }
    }
    
    func updateActiveTrip() {
        if let newActiveTrip = trips.first(where: { $0.trip.tripID == selectedTrip }) {
            activeTrip = newActiveTrip
            cameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: Double(newActiveTrip.position.latitude), longitude: Double(newActiveTrip.position.longitude)), distance: 1000))
        }
    }
}
