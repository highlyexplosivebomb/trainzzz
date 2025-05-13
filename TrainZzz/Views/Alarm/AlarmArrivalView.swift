//
//  AlarmArrivalView.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//

import SwiftUI

struct AlarmArrivalView: View {
    @Binding var navigationPath: NavigationPath
    
    @EnvironmentObject var audioHelper: AlarmAudioHelper
    
    var body: some View {
        VStack {
            AlarmGIFView()
                .padding()
                .frame(maxHeight: 300)
            
            Text("You've Arrived!")
                .font(.largeTitle)
                .bold()
                .padding()
            
            VStack {
                Button("Stop Alarm", action: {
                    audioHelper.stopAlarmSound()
                })
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.bottom)
                
                Button("Create Another Alarm") {
                    navigationPath.removeLast(navigationPath.count)
                }
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarBackButtonHidden(true)
        .onDisappear() {
            audioHelper.stopAlarmSound()
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    
    return AlarmArrivalView(navigationPath: .constant(NavigationPath()))
        .environmentObject(audioHelper)
}
