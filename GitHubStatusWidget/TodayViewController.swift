//
//  TodayViewController.swift
//  GitHubStatusWidget
//
//  Created by Thomas Prezioso on 2/17/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var wigetLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    var statusForSharing = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        setBackGroundColorForStatus(status: statusForSharing)
    }
    
    func setBackGroundColorForStatus(status:String) {
        switch status {
        case "good":
            self.statusLabel.backgroundColor = UIColor.green
        case "minor":
            self.statusLabel.backgroundColor = UIColor.yellow
        case "major":
            self.statusLabel.backgroundColor = UIColor.red
        default:
            self.statusLabel.backgroundColor = UIColor.white
        }
    }
    
    func updateLabel() {
        let defaults = UserDefaults.init(suiteName: "group.GitHubStatusWidget")
        let status = defaults!.string(forKey: "status")
        statusForSharing = status!
        let lastUpdate = defaults!.string(forKey: "lastUpdate")
        self.wigetLabel.text = " \(lastUpdate!)\n \(status!)"
        print(self.wigetLabel.text!)
        print("\(status!)")
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
