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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        updateLabel()
    }
    
    func updateLabel() {
        let defaults = UserDefaults.init(suiteName: "group.GitHubStatusWidget")
        let status = defaults!.string(forKey: "status")
        let body = defaults!.string(forKey: "body")
        self.wigetLabel.text = "GitHub Status\n\(status!) \n\(body!)"
        print(self.wigetLabel.text!)
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
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
