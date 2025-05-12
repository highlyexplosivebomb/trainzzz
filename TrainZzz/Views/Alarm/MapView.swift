//
//  MapView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    let coordinate: CLLocationCoordinate2D

    @State private var position: MapCameraPosition

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        _position = State(initialValue: .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        ))
    }

    var body: some View {
        Map(initialPosition: position)
        .frame(height: 200)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
    }
}


#Preview {
    let coordinate = CLLocationCoordinate2D(latitude: -33.863596, longitude: 151.208975)
    MapView(coordinate: coordinate)
}
