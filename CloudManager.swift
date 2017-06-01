//
//  CloudManager.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
//import NotificationCenter
import MobileCoreServices
import CloudKit

class CloudManager {
    
    private let container = CKContainer(identifier: "iCloud.barnard.developments.BatteryMonitor")
    private var privateDatabase: CKDatabase?
    private var recordZone: CKRecordZone?
    
    private var batteryStatus: ABatteryStatus?
    
    init() {
        
        privateDatabase = container.privateCloudDatabase
        recordZone = CKRecordZone(zoneName: "MonitorZone")
        
        privateDatabase?.save(recordZone!,
                              completionHandler: {(recordzone, error) in
                                if (error != nil) {
                                   print("error")
                                } else {
                                    print("Saved record zone")
                                }
        })
    }
    
    func getAllRecord(getCompleted : @escaping (_ succeeded: Bool, _ batteryStatuses: [ABatteryStatus]? ) -> ()) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "DeviceStatus", predicate: predicate)
        
        privateDatabase?.perform(query, inZoneWith: recordZone?.zoneID,
                 completionHandler: ({results, error in
                    
                    if (error != nil) {
                        DispatchQueue.main.async() {
                            print(error ?? "Unknown")
                            getCompleted(false, nil)
                            
                        }
                    } else {
                        if results!.count > 0 {
                            
                            var allBatteryStatus = [ABatteryStatus]()
                            
                            for result in results! {
                                
                                let batteryStatus = ABatteryStatus(
                                    name: result.object(forKey: "name") as! String,
                                    timestamp: result.object(forKey: "timestamp") as! Date,
                                    batteryLevel: result.object(forKey: "level") as! Float,
                                    deviceUUID: result.object(forKey: "uuid") as! String
                                )
                                
                                allBatteryStatus.append(batteryStatus)
                            }
                            
                            DispatchQueue.main.async() {
                                getCompleted(true, allBatteryStatus)
                            }
                        } else {
                            DispatchQueue.main.async() {
                                getCompleted(false, nil)
                                
                            }
                        }
                    }
                }
        ))
    }

    
    func updateRecords( _ batteryStatus: ABatteryStatus, updateCompleted : @escaping (_ succeeded: Bool) -> ()) {
        
        self.batteryStatus = batteryStatus
        
        getRecord(name: batteryStatus.name) { (exists, record) in
            
            if exists && record != nil {
                self.updateRecord(record: record!, updateCompleted: { (updated) in
                    updateCompleted(updated)
                })
            } else {
                self.insertRecord(insertCompleted: { (inserted) in
                    updateCompleted(inserted)
                })
            }
        }
    }
    
    private func getRecord( name: String,  getCompleted : @escaping (_ succeeded: Bool, _ record: CKRecord? ) -> ()) {
        
        let predicate = NSPredicate(format: "name = %@", name )
        
        let query = CKQuery(recordType: "DeviceStatus", predicate: predicate)
        
        privateDatabase?.perform(query, inZoneWith: recordZone?.zoneID,
                 completionHandler: ({results, error in
                    
                    if (error != nil) {
                        DispatchQueue.main.async() {
                            getCompleted(false, nil)
                            
                        }
                    } else {
                        if results!.count > 0 {
                            
                            let record = results![0]
                            
                            DispatchQueue.main.async() {
                                getCompleted(true, record)
                            }
                        } else {
                            DispatchQueue.main.async() {
                                getCompleted(false, nil)
                                
                            }
                        }
                    }
                }
        ))
    }
    
    private func updateRecord( record: CKRecord, updateCompleted : @escaping (_ succeeded: Bool ) -> ()) {
        
            
        record.setObject(self.batteryStatus!.batteryLevel as CKRecordValue?, forKey: "level")
        record.setObject(self.batteryStatus!.deviceUUID as CKRecordValue, forKey: "uuid")
        record.setObject(self.batteryStatus!.name as CKRecordValue, forKey: "name")
        record.setObject(self.batteryStatus!.timestamp! as CKRecordValue, forKey: "timestamp")
        
        privateDatabase?.save(record, completionHandler:
            ({returnRecord, error in
                if let _ = error {
                    DispatchQueue.main.async() {
                        updateCompleted(false)
                    }
                } else {
                    DispatchQueue.main.async() {
                        updateCompleted(true)
                    }
                }
            }))
    }
    
    private func insertRecord(insertCompleted : @escaping (_ succeeded: Bool ) -> ()) {
        
        let myRecord = CKRecord(recordType: "DeviceStatus",
                                zoneID: (recordZone?.zoneID)!)
        
        myRecord.setObject(self.batteryStatus!.batteryLevel as CKRecordValue, forKey: "level")
        myRecord.setObject(self.batteryStatus!.deviceUUID as CKRecordValue, forKey: "uuid")
        myRecord.setObject(self.batteryStatus!.name as CKRecordValue, forKey: "name")
        myRecord.setObject(self.batteryStatus!.timestamp! as CKRecordValue, forKey: "timestamp")

        
        let modifyRecordsOperation = CKModifyRecordsOperation(
            recordsToSave: [myRecord],
            recordIDsToDelete: nil)
        
        modifyRecordsOperation.timeoutIntervalForRequest = 10
        modifyRecordsOperation.timeoutIntervalForResource = 10
        
        modifyRecordsOperation.modifyRecordsCompletionBlock =
            { records, recordIDs, error in
                if let _ = error {
                   insertCompleted(false)
                } else {
                    DispatchQueue.main.async {
                        insertCompleted(true)
                    }
                }
        }
        privateDatabase?.add(modifyRecordsOperation)
    }
}
