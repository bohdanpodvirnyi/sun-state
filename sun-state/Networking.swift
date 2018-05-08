//
//  Networking.swift
//  sun-state
//
//  Created by hell 'n silence on 5/8/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import Alamofire
import UIKit

typealias JSON = [String: Any]

class Networking {
    static let shared = Networking()
    private init() {}
    
    func getTime(completion: @escaping (Bool) -> (), lat: Double, long: Double) {
        //MARK: - Making request to API
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = "https://api.sunrise-sunset.org/json?lat=\(lat)&lng=\(long)"
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value as? JSON {
                if (json["status"] as! String == "OK") {
                    //MARK: - Getting data from request
                    let jsonResult:Dictionary = json["results"] as! Dictionary<String, Any>
                    let sunrise:String = jsonResult["sunrise"] as! String
                    let sunset:String = jsonResult["sunset"] as! String
                    UserDefaults.standard.set(sunrise, forKey: "sunrise")
                    UserDefaults.standard.set(sunset, forKey: "sunset")
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                print("result is nil")
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
