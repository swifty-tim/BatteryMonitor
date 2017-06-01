//
//  DeviceWidgetTableViewCell.swift
//  BatteryMonitor
//
//  Created by Timothy Barnard on 29/05/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

class DeviceWidgetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var batteryLevelLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
