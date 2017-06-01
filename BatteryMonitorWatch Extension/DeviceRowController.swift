//
//  DeviceRowController.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import WatchKit

class DeviceRowController: NSObject {
    
    @IBOutlet var levelIndicator: WKInterfaceSeparator!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var levelLabel: WKInterfaceLabel!
    @IBOutlet var timeStamp: WKInterfaceLabel!
    
    
    var device: ABatteryStatus? {
        didSet {
            
            guard let device = device else { return }
            
            
            nameLabel.setText(device.name)
            levelLabel.setText("\(device.batteryLevel!) %")
            timeStamp.setText(device.dateTimeString!)
            levelIndicator.setColor(device.batteryLevelColor)
        }
    }
}
