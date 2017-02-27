//
//  TodayViewController.swift
//  GitHubStatusWidget
//
//  Created by Thomas Prezioso on 2/17/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())

        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var wigetLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }
    
    // MARK: - Setup Label
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
    
    // MARK: - API Call
    func updateLabel() {
        Alamofire.request("https://status.github.com/api/status.json").responseJSON { response in
            if let JSON = response.result.value {
                let data = JSON as? [String: Any]
                let status = data?["status"] as! String?
                let date = data?["last_updated"] as! String?
                let convertedDate = self.getDateFromJSONData(dateString: date!)
                self.setBackGroundColorForStatus(status: status!)
                self.wigetLabel.text = " Status: \(status!.capitalizingFirstLetter())\n\n \(convertedDate)"
            }
        }
    }

    // MARK: - Helper Methods
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

    @IBAction func sendToGitHubStatus(_ sender: Any) {
        let appURL = NSURL(string: "https://status.github.com/")
        self.extensionContext?.open(appURL! as URL, completionHandler:nil)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
