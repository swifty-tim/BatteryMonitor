//
//  ABatteryStatus.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#elseif os(watchOS)
    import WatchKit
#endif


enum BatteryHealth {
    case Low
    case Middle
    case Full
}

struct ABatteryStatus {
    
    var deviceUUID: String!
    var name:String!
    var timestamp: Date!
    var batteryLevel: Float!
    var dateTimeString: String!
    var batteryLevelStage: BatteryHealth!
    var batteryLevelColor: UIColor!
    
    init(name:String, timestamp:Date, batteryLevel: Float, deviceUUID: String ) {
        self.batteryLevel = batteryLevel
        self.name = name
        self.timestamp = timestamp
        self.deviceUUID = deviceUUID
        
        self.getCurrentLocalDate()
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(name: "GMT") as TimeZone!
        formatter.dateFormat = "HH:mm yyyy-MM-dd"
        self.dateTimeString = formatter.string(from: self.timestamp)
        
        switch self.batteryLevel {
        case _ where self.batteryLevel < 30:
            self.batteryLevelStage = .Low
            self.batteryLevelColor = UIColor.red
            break
        case _ where self.batteryLevel > 30 && self.batteryLevel < 60:
            self.batteryLevelStage = .Middle
            self.batteryLevelColor = UIColor.orange
            break
        default:
            self.batteryLevelStage = .Full
            self.batteryLevelColor = UIColor(red: 44/255, green: 103/255, blue: 0/255, alpha: 1)
        }

    }
    
    mutating func getCurrentLocalDate() {
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: self.timestamp)
        nowComponents.month = Calendar.current.component(.month, from: self.timestamp)
        nowComponents.day = Calendar.current.component(.day, from: self.timestamp)
        nowComponents.hour = Calendar.current.component(.hour, from: self.timestamp)
        nowComponents.minute = Calendar.current.component(.minute, from: self.timestamp)
        nowComponents.second = Calendar.current.component(.second, from: self.timestamp)
        nowComponents.timeZone = TimeZone(abbreviation: "GMT")!
        self.timestamp = calendar.date(from: nowComponents)!
    }
}
