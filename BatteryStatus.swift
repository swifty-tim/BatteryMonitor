//
//  BatteryStatus.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

struct BatteryStatus {
    
    var deviceUUID: String!
    var name:String!
    var timestamp: Date!
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel * Float(100)
    }
    
    var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
    
    init() {
        //self.batteryStatus = batteryStatus
        self.name = UIDevice.current.name
        self.deviceUUID = UUID().uuidString
        self.timestamp = Date()
        
    }
}
