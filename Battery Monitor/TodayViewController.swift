//
//  TodayViewController.swift
//  Battery Monitor
//
//  Created by Timothy Barnard on 28/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var data  = [ABatteryStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        self.preferredContentSize.height = 200
        
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        loadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController {
    
    // MARK: - Loading of data
    
    func loadData() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.data.removeAll()
            
            let cloudManager = CloudManager()
            
            cloudManager.updateRecords(updateCompleted: { (complete) in
                
            })
            
            cloudManager.getAllRecord(getCompleted: { (complete, results) in
                
                DispatchQueue.main.async {
                    if complete {
                        self.data = results!
                        self.tableView.reloadData()
                    }
                }
            })
            
           
        }
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceIdentifier", for: indexPath)
        
        let item = data[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.batteryLevel) %"
        cell.textLabel?.textColor = UIColor.white
        
        print(item.name)
        
        return cell
    }
}
