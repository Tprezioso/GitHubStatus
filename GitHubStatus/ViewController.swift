//
//  ViewController.swift
//  GitHubStatus
//
//  Created by Thomas Prezioso on 2/16/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import UIKit
import Alamofire
import BXProgressHUD

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

class ViewController: UIViewController {
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var lastUpdatedLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var octocatImage: UIImageView!
    @IBOutlet var poweredByLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        startTheApp()
    }

    // MARK: - Setup View
  
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
        
        let octImage : UIImage = UIImage(named: "Octocat.png")!
        octocatImage.contentMode = .scaleAspectFit
        octocatImage.image = octImage
    }
    
    func setBackGroundColorForStatus(status:String) {
        switch status {
            case "good":
                self.view.backgroundColor = UIColor.green
            case "minor":
                self.view.backgroundColor = UIColor.yellow
                self.lastUpdatedLabel.textColor = UIColor.black
                self.statusLabel.textColor = UIColor.black
                self.poweredByLabel.textColor = UIColor.black
            case "major":
                self.view.backgroundColor = UIColor.red
            default:
                self.view.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - Helper Method(s)
    
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

    // MARK: - Check for internet connection using reachability
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            print("Unreachable")
//            view.backgroundColor = .red
            let hud = BXHUD.self
            hud.hideSuccess()
        case .wifi:
            print("WIFI")
            view.backgroundColor = .green
        case .wwan:
            print("this is working?")
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }

    
    // MARK: - API Call
    
    func api() {
        let hud = BXHUD.showProgress("Loading")
        Alamofire.request("https://status.github.com/api/status.json").responseJSON { response in
            self.view.addSubview(hud)
            if let JSON = response.result.value {
                let data = JSON as? [String: Any]
                let status = data?["status"] as! String?
                self.statusLabel.text = " Status: \(status!.capitalizingFirstLetter())"
                let date = data?["last_updated"] as! String?
                self.setBackGroundColorForStatus(status: status!)
                self.lastUpdatedLabel.text = self.getDateFromJSONData(dateString: date!)
                hud.hide(afterDelay: 0.5)
            }
        }
    }
    
    // MARK: - Method Called On viewDidLoad Method
    
    func startTheApp() {
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        api()
    }

    // MARK: - Action Method(s)
    
    @IBAction func openURLButton(_ sender: Any) {
        let url = URL(string: "https://status.github.com/")
        UIApplication.shared.open(url!)
    }
}

