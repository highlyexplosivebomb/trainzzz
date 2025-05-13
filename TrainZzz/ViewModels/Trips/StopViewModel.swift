//
//  StopViewModel.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 10/5/2025.
//

import Foundation
import SwiftUI

class StopViewModel : ObservableObject
{
    @Published var allStops: [Stop] = []
    @Published var stops: [Stop] = []
    @Published var searchText: String = "" {
        didSet {
            filterStops()
        }
    }

    // Create an index for fast searching
    var stopNameIndex: [String: [Stop]] = [:]

    init(allStops: [Stop]) {
        self.allStops = allStops
        self.stops = Array(allStops.prefix(20))
        buildIndex()
    }

    func buildIndex() {
        // Create an index based on the first 3 characters of the stopName
        for stop in allStops {
            let key = stop.stopName.prefix(3).lowercased()
            stopNameIndex[key, default: []].append(stop)
        }
    }

    func filterStops() {
        if searchText.isEmpty {
            stops = Array(allStops.prefix(20)) // Default to top 10
        } else {
            // Search using the index
            let key = searchText.prefix(3).lowercased()
            if let possibleMatches = stopNameIndex[key] {
                stops = possibleMatches.filter {
                    $0.stopName.localizedCaseInsensitiveContains(searchText)
                }
            } else {
                stops = [] // No matches
            }
        }
    }

}
