//
//  ViewController.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var batteryStateLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!

    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDeviceBatteryState {
        return UIDevice.current.batteryState
    }
    
    var cloudManager: CloudManager?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudManager = CloudManager()
        
        UIDevice.current.isBatteryMonitoringEnabled = true

        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: .UIDeviceBatteryLevelDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: .UIDeviceBatteryStateDidChange, object: nil)
        
//        let notificationManager = NotificationManager()
//        notificationManager.registerForNotifications()
//        notificationManager.cancelAllNotifications()
//        
//        notificationManager.testModeNotificaitons()
        
        self.updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func batteryStateDidChange(_ notification: NSNotification){
        print(batteryState)
        self.updateViews()
    }

    
    func batteryLevelDidChange(_ notification: Notification) {
        print(batteryLevel)
        self.updateViews()
    }
    
    func notifyUser(_ title: String, message: String) -> Void {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    func updateViews() {
        
        self.batteryLevelLabel.text = "\(batteryLevel * 100) %"
        
        switch batteryState {
        case .unplugged, .unknown:
            self.batteryStateLabel.text = "not charging"
        case .charging, .full:
            self.batteryStateLabel.text = "charging or full"
        }
        
        
        let deviceStatus = BatteryStatus()
        
        let aDeviceStatus = ABatteryStatus( name: deviceStatus.name,
                                            timestamp: deviceStatus.timestamp,
                                            batteryLevel: deviceStatus.batteryLevel,
                                            deviceUUID: deviceStatus.deviceUUID)
        
        cloudManager?.updateRecords(aDeviceStatus, updateCompleted: { ( complete) in
            
            if complete {
                self.notifyUser("Success", message: "Record sent")
            } else {
                self.notifyUser("Error", message: "Record not sent")
            }
        })
        
    }
    
        
//    func manager(_ manager: Manager, willConnectToDevice device: Device) {
//        print(device.peripheral.name ?? "Unknown")
//        
//    }
//    
//    func manager(_ manager: Manager, didFindDevice device: Device) {
//        print(device.peripheral.name ?? "Unknown")
//    }
//   
//    func manager(_ manager: Manager, connectedToDevice device: Device) {
//        print(device.peripheral.name ?? "Unknown")
//    }
//    
//   
//    func manager(_ manager: Manager, disconnectedFromDevice device: Device, willRetry retry: Bool) {
//        print(device.peripheral.name ?? "Unknown")
//    }

}



