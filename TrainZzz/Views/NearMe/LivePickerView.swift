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
    
    var body: some View {
        VStack {
            if let activeTrip = activeTrip {
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: Double(activeTrip.position.latitude), longitude: Double(activeTrip.position.longitude))) {
                        TransportModeLogo(isTrain: true, isSmall: true)
                    }
                }
                Text("Timer: \(timer)  |  Trip Refreshed: \(activeTrip.timestamp)")
            } else {
                Text("No real-time data available for this trip.")
            }
        }
        .onChange(of: timer) {
            updateActiveTrip()
        }
    }
    
    func updateActiveTrip() {
        if let newActiveTrip = trips.first(where: { $0.trip.tripID == selectedTrip }) {
            activeTrip = newActiveTrip
            cameraPosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: Double(newActiveTrip.position.latitude), longitude: Double(newActiveTrip.position.longitude)), distance: 1000))
        }
    }
}
