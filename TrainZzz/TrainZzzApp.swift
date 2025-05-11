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
    @AppStorage("isSetupComplete") private var isSetupComplete: Bool = false

    init() {
        let audioHelper = AlarmAudioHelper()
        _alarmAudioHelper = StateObject(wrappedValue: audioHelper)
        _locationManager = StateObject(wrappedValue: AppLocationManager(audioHelper: audioHelper))
    }

//    var body: some Scene {
//        WindowGroup {
//            if isSetupComplete {
//                // ✅ App is setup – show main navigation UI
//                MainTabView()
//                    .environmentObject(locationManager)
//                    .environmentObject(alarmAudioHelper)
//            } else {
//                // ❗ No navigation bar here
//                SetupView(viewModel: SetupViewModel(locationManager: locationManager))
//                    .environmentObject(locationManager)
//                    .environmentObject(alarmAudioHelper)
//            }
//        }
//    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                SetupView(viewModel: SetupViewModel(locationManager: locationManager))
                    .opacity(isSetupComplete ? 0 : 1)
                    .zIndex(isSetupComplete ? 0 : 1)
                    .environmentObject(locationManager)
                    .environmentObject(alarmAudioHelper)

                MainTabView()
                    .opacity(isSetupComplete ? 1 : 0)
                    .zIndex(isSetupComplete ? 1 : 0)
                    .environmentObject(locationManager)
                    .environmentObject(alarmAudioHelper)
            }
            .animation(.snappy, value: isSetupComplete)
        }
    }

}

