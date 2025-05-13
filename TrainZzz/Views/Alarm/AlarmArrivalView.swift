//
//  AlarmArrivalView.swift
//  TrainZzz
//
//  Created by Justin Wong on 13/5/2025.
//

import SwiftUI

struct AlarmArrivalView: View {
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
                
                NavigationLink(destination: AlarmConfigView()) {
                    Text("Create Another Alarm")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                }
                .cornerRadius(20)
                .padding()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    let audioHelper = AlarmAudioHelper()
    
    return AlarmArrivalView()
        .environmentObject(audioHelper)
}
