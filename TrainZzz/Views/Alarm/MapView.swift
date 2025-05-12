//
//  MapView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var coordinate: CLLocationCoordinate2D

    @State private var position: MapCameraPosition

    init(coordinate: Binding<CLLocationCoordinate2D>) {
        self._coordinate = coordinate
        self._position = State(initialValue: .region(
            MKCoordinateRegion(
                center: coordinate.wrappedValue,
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
