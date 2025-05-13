//
//  MapView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    let coordinate: MapCoordinate

    @State private var position: MapCameraPosition

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = MapCoordinate(coord: coordinate)
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        Map(position: $position)
        .frame(height: 200)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
        .onChange(of: coordinate) { oldValue, newValue in
            position = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: newValue.latitude, longitude: newValue.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}

#Preview {
    let coordinate = CLLocationCoordinate2D(latitude: -33.863596, longitude: 151.208975)
    MapView(coordinate: coordinate)
}
