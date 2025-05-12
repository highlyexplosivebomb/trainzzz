//
//  AlarmConfigViewModel.swift
//  TrainZzz
//
//  Created by Justin Wong on 12/5/2025.
//

import Foundation
import SwiftUI

class AlarmConfigViewModel: ObservableObject {
    @Published var destination: Stop? = nil
    @Published var allStops: [Stop] = []

    init()
    {
        allStops = loadStops()
    }

    func loadStops() -> [Stop] {
        if let url = Bundle.main.url(forResource: "stops", withExtension: "txt"),
           let contents = try? String(contentsOf: url, encoding: .utf8) {
            return ParsingHelper.parseStopsCSV(from: contents)
        }
        return []
    }
}
