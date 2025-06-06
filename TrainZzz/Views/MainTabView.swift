//
//  NavigationView.swift
//  TrainZzz
//
//  Created by John Ly on 5/5/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MainTripsView()
                .tabItem {
                    Image(systemName: "train.side.front.car")
                    Text("Trips")
                }
            
            AlarmRootView()
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Alarm")
                }
            
            NearMeView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Near Me")
                }
        }.navigationBarHidden(true)
    }
}

#Preview {
    MainTabView()
}
