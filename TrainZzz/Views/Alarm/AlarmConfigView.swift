//
//  AlarmConfigView.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import SwiftUI
import CoreLocation

struct AlarmConfigView: View {
    @Binding var navigationPath: NavigationPath
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var alarmConfigViewModel = AlarmConfigViewModel()
    @StateObject private var destinationViewModel: StopViewModel

    @FocusState private var isFieldFocused: Bool

    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
        let alarmConfigVM = AlarmConfigViewModel()
        _alarmConfigViewModel = StateObject(wrappedValue: alarmConfigVM)
        _destinationViewModel = StateObject(wrappedValue: StopViewModel(allStops: alarmConfigVM.allStops))
    }

    var body: some View {
        ScrollView {
            Spacer()
            Text("Configure Your Alarm")
                .font(.largeTitle)
                .bold()
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Radius: \(Int(alarmConfigViewModel.alarmRadius))m")
                    .bold()
                    .padding(.horizontal)
                Slider(value: $alarmConfigViewModel.alarmRadius, in: 200...1500, step: 100)
                    .padding()
            }
            .padding()
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Your Destination")
                        .font(.title3)
                        .fontWeight(.semibold)

                    TextField("Start typing...", text: $destinationViewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .focused($isFieldFocused)

                    if !destinationViewModel.stops.isEmpty && isFieldFocused {
                        DestinationDropdownListView(stops: destinationViewModel.stops) { stop in
                            alarmConfigViewModel.destination = stop
                            destinationViewModel.searchText = stop.stopName
                            isFieldFocused = false
                        }
                        .background(colorScheme == .dark ? Color(.darkGray) : Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.top, -8)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(colorScheme == .dark ? Color(.darkGray) : Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .padding(.horizontal)
            }
            .animation(.easeInOut, value: isFieldFocused)
            .padding(.bottom)
            
            if let destination = alarmConfigViewModel.destination {
                let coordinate = CLLocationCoordinate2D(latitude: destination.stopLat, longitude: destination.stopLon)

                Button("Start Alarm") {
                    navigationPath.append(AlarmRoute.journey(
                        target: MapCoordinate(coord: coordinate),
                        radius: alarmConfigViewModel.alarmRadius,
                        name: destination.stopName
                    ))
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                .padding()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    AlarmConfigView(navigationPath: .constant(NavigationPath()))
}
