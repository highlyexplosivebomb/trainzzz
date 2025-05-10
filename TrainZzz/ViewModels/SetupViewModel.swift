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
    @Published public var startIsDisabled = true
    private var locationManager = SetupLocationManager()
    
    var hasLocationPermissions : Bool {
        get
        {
            return locationManager.authorisationStatus == .authorizedWhenInUse || locationManager.authorisationStatus == .authorizedAlways
        }
    }
    
    func request()
    {
        locationManager.request()
        if(hasLocationPermissions)
        {
            startIsDisabled = false
        }
    }
    
    func checkForExistingPermissions()
    {
        if(hasLocationPermissions){
            isSetup = true
        }
    }
}
