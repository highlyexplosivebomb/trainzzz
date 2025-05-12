//
//  FacilityInfo.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct FacilityInfo: View {
    let facility: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
            Text(facility)
            Spacer()
        }
    }
}
