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
            TripsView()
                .tabItem {
                    Image(systemName: "train.side.front.car")
                    Text("Trips")
                }
            
            NavigationStack {
                AlarmConfigView()
            }
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
