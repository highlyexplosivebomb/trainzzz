//
//  TrainZzzApp.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

@main
struct TrainZzzApp: App {
    @StateObject private var locationManager: AppLocationManager
    @StateObject private var alarmAudioHelper: AlarmAudioHelper
    @StateObject private var setupViewModel: SetupViewModel

    init() {
        let audioHelper = AlarmAudioHelper()
        let appLocationManager = AppLocationManager(audioHelper: audioHelper)
        _alarmAudioHelper = StateObject(wrappedValue: audioHelper)
        _locationManager = StateObject(wrappedValue: appLocationManager)
        _setupViewModel = StateObject(wrappedValue: SetupViewModel(locationManager: appLocationManager))
    }
    
    var body: some Scene {
        WindowGroup {
            if setupViewModel.isSetupComplete {
                MainTabView()
                    .environmentObject(locationManager)
                    .environmentObject(alarmAudioHelper)
            } else {
                SetupView(viewModel: setupViewModel)
                    .environmentObject(locationManager)
                    .environmentObject(alarmAudioHelper)
            }
        }
    }
}
