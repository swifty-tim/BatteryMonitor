//
//  InterfaceController.swift
//  BatteryMonitorWatch Extension
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var devicesTable: WKInterfaceTable!
    
    var allDevices = [ABatteryStatus]()
    var selectedIndex = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.getAllDevices()
    }
    
    func updateTableView() {
        
        devicesTable.setNumberOfRows(allDevices.count, withRowType: "DeviceRow")
        
        for index in 0..<devicesTable.numberOfRows {
            guard let controller = devicesTable.rowController(at: index) as? DeviceRowController else { continue }
            
            controller.device = allDevices[index]
        }
        
    }
    
    func getAllDevices() {
        
        //DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.allDevices.removeAll()
            
            let cloudManager = CloudManager()
            
            cloudManager.getAllRecord(getCompleted: { (complete, results) in
                
                //DispatchQueue.main.async {
                    if complete {
                        self.allDevices = results!
                        self.updateTableView()
                    }
                //}
            })
            
            
        //}

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
//        let friend = allDevices[rowIndex]
//        selectedIndex = rowIndex
//        let controllers = ["Friend"]
//        presentController(withNames: controllers, contexts: [friend])
    }
    
    
}
