//
//  SetupViewModel.swift
//  TrainZzz
//
//  Created by Lachlan Giang on 9/5/2025.
//

import Foundation
import SwiftUI

class SetupViewModel : ObservableObject
{
    @Published public var permissionNotGranted = false
    @Published public var isSetupComplete = true
    
    private let locationManager: AppLocationManager
    
    init(locationManager: AppLocationManager) {
        self.locationManager = locationManager
        isSetupComplete = hasLocationPermissions
    }
    
    var hasLocationPermissions : Bool {
        return locationManager.authorisationStatus == .authorizedAlways
    }
    
    func request()
    {
        locationManager.request()
    }
    
    func startButtonClick() {
        if(!checkForExistingPermissions())
        {
            permissionNotGranted = true
        }
    }
    
    func checkForExistingPermissions() -> Bool
    {
        if(hasLocationPermissions)
        {
            isSetupComplete = true
            return true;
        }
        return false;
    }
}
