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
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://status.github.com/api/last-message.json").responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let dataFromJson = JSON as? [String: Any]
               // print("\(dataFromJson?["created_on"]!)")
                let statusString = dataFromJson?["status"] as! String?
                self.statusLabel.text = "GitHub Status:\n\(statusString!)"
                self.bodyLabel.text = dataFromJson?["body"] as! String?
                self.lastUpdatedLabel.text = dataFromJson?["created_on"] as! String?
            }
        }
        let image : UIImage = UIImage(named: "Octicons-mark-github.svg.png")!
        let imageView1 = UIImageView(frame: CGRect(x:0, y: 0, width: 40, height: 40))
        imageView1.contentMode = .scaleAspectFit
        imageView1.image = image
        self.navigationItem.titleView = imageView1
        self.view.backgroundColor = UIColor.green
    }
}

