//
//  TransportModeLogo.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct TransportModeLogo: View {
    let isTrain: Bool
    let isSmall: Bool
    
    var body: some View {
        Image(isTrain ? "SydneyTrainsIcon" : "SydneyMetroIcon")
            .resizable()
            .scaledToFit()
            .frame(width: isSmall ? 20 : 50, height: isSmall ? 20 : 50)
            .shadow(radius: 3)
    }
}
