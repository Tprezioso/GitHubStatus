//
//  APICalls.swift
//  GitHubStatus
//
//  Created by Thomas Prezioso on 2/17/17.
//  Copyright © 2017 Thomas Prezioso. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

struct APICALL {
   
    func currentStatus() -> (String, String) {
        var status = ""
        var date = ""
        Alamofire.request("https://status.github.com/api/status.json").responseJSON { response in
            if let JSON = response.result.value {
                var data = JSON as? [String: Any]
                status = (data?["status"] as! String?)!
                date = (data?["last_updated"] as! String?)!
            }
        }
        return (status, date)
    }
}
