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
    @Published public var isSetup: Bool = false
    @Published public var permissionNotGranted = false
    private var locationManager = SetupLocationManager()
    
    var hasLocationPermissions : Bool {
            return locationManager.authorisationStatus == .authorizedWhenInUse || locationManager.authorisationStatus == .authorizedAlways
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
            isSetup = true
            return true;
        }
        return false;
    }
}
