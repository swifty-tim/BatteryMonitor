//
//  NotificationManager.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 29/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

import UserNotifications

enum NotificationAction : String {
    case myClass = "myClass"
}

class NotificationManager: NSObject {
    
    private var notificationGranted : Bool = true
    
    func registerForNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                self.notificationGranted = granted
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func notificationsCount() -> Int {
        
        var returnCount = 0
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { (notifications) in
                print("Count: \(notifications.count)")
                returnCount = notifications.count
            }
        }
        return returnCount
    }
    
    func cancelAllNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func removeANotification( notificaitonID : Int ) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(notificaitonID)])
        } else {
            // Fallback on earlier versions
        }
    }
    

    func createNotification( day : Int,  time : String, name : String, room : String, lecture : String, id : String, minsBefore: Int) {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Class Starts"
            content.body = name + " is starting at: "+time+".\nRoom: "+room+"\nLecture: "+lecture
            content.categoryIdentifier = "com.barnard.localNotification"

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            center.add(request) { (error) in
                if error != nil {
                    print(error ?? "Testing")
                }
            }
        }
        
    }
    
    func testModeNotificaitons() {
        self.createNotification(day: 0, time: "22:10", name: "test mode", room: "", lecture: "", id : String(99999), minsBefore: 1 )
    }
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        // Response has actionIdentifier, userText, Notification (which has Request, which has Trigger and Content)
        switch response.actionIdentifier {
        case NotificationAction.myClass.rawValue:
            print("High Five Delivered!")
        default: break
        }
    }
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        // Delivers a notification to an app running in the foreground.
    }
}

