//
//  ViewController.swift
//  GitHubStatus
//
//  Created by Thomas Prezioso on 2/16/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://status.github.com/api/last-message.json").responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let dataFromJson = JSON as? [String: Any]
                print("\(dataFromJson?["status"]!)")
                self.statusLabel.text = dataFromJson?["status"] as! String?
            }
        }
    }
}

