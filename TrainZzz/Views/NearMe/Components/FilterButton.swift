//
//  FilterButton.swift
//  TrainZzz
//
//  Created by John Ly on 12/5/2025.
//

import Foundation
import SwiftUI

struct FilterButton: View {
    @State private var isActive: Bool = false
    @State private var buttonColor: Color = Color(.systemGray5)
    @Binding var filters: [String]
    let icon: String
    let text: String
    let filter: String
    
    var body: some View {
        Button(action: {
            buttonColor = isActive ? Color(.systemGray5) : .mint
            isActive = isActive ? false : true
            switch isActive {
            case true:
                filters.append(filter)
            case false:
                filters.removeAll { $0 == filter }
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                Text(text)
            }
            .frame(maxHeight: 25, alignment: .leading)
        }
        .padding(6)
        .background(buttonColor)
        .cornerRadius(5)
        .foregroundColor(Color.black)
    }
}
