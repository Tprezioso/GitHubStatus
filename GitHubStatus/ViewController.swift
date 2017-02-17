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

    func setupViews() {
        let navImage : UIImage = UIImage(named: "Octicons-mark-github.svg.png")!
        let navImageView = UIImageView(frame: CGRect(x:0, y: 0, width: 40, height: 40))
        navImageView.contentMode = .scaleAspectFit
        navImageView.image = navImage
        self.navigationItem.titleView = navImageView
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, at: 0)
        
        let backgroundImage : UIImage = UIImage(named: "Octocat.png")!
        let backgroundImageView = UIImageView(frame: CGRect(x:0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        backgroundImageView.contentMode = .scaleAspectFit
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    func setBackGroundColorForStatus(status:String) {
        switch status {
        case "good":
            self.view.backgroundColor = UIColor.green
        case "minor":
            self.view.backgroundColor = UIColor.yellow
        case "major":
            self.view.backgroundColor = UIColor.red
        default:
            self.view.backgroundColor = UIColor.white
        }
    }
    
    func takeStringFromBeging(stringToCut:String ,start: Int, end: Int) -> String {
        let startIndex = stringToCut.index(stringToCut.startIndex, offsetBy: start)
        let endIndex = stringToCut.index(stringToCut.startIndex, offsetBy: end)
        
        return stringToCut[startIndex...endIndex]
    }
    
    func getDateFromJSONData(dateString: String) -> String {
        let day = takeStringFromBeging(stringToCut: dateString, start: 8, end: 9)
        let month = takeStringFromBeging(stringToCut: dateString, start: 5, end: 6)
        let year = takeStringFromBeging(stringToCut: dateString, start: 0, end: 3)

        return "Last Updated\n\(month)/\(day)/\(year)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Alamofire.request("https://status.github.com/api/last-message.json").responseJSON { response in
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let dataFromJson = JSON as? [String: Any]
                let statusString = dataFromJson?["status"] as! String?
                let dateToChange = dataFromJson?["created_on"] as! String?
                let bodyString = dataFromJson?["body"] as! String?
                self.statusLabel.text = "GitHub Status\n\(statusString!)"
                self.bodyLabel.text = dataFromJson?["body"] as! String?
                self.setBackGroundColorForStatus(status: statusString!)
                self.lastUpdatedLabel.text = self.getDateFromJSONData(dateString: dateToChange!)
                let extenstionDefault = UserDefaults.init(suiteName: "group.GitHubStatusWidget")
                extenstionDefault?.set(statusString, forKey: "status")
                extenstionDefault?.set(bodyString, forKey: "body")
                extenstionDefault?.synchronize()
                print("\(extenstionDefault?.value(forKey: "status")!)")
            }
        }
    }
}

