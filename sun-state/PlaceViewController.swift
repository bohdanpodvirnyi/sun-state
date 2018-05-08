//
//  PlaceViewController.swift
//  sun-state
//
//  Created by hell 'n silence on 5/8/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {

    var latitude: Double = 0
    var longitude: Double = 0
    var name: String = ""
    var sunrise: String = ""
    var sunset: String = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        loading.hidesWhenStopped = true
        Networking.shared.getTime(completion: { q in
            if !q {
                print("error")
            } else {
                self.dataDidArrived()
            }
        }, lat: latitude, long: longitude)
    }
    
    //MARK: - Setting all variables when data did arrived
    func dataDidArrived() {
        loading.stopAnimating()
        name = UserDefaults.standard.string(forKey: "name")!
        sunrise = UserDefaults.standard.string(forKey: "sunrise")!
        sunset = UserDefaults.standard.string(forKey: "sunset")!
        nameLabel.text = name
        sunriseLabel.text = sunrise
        sunsetLabel.text = sunset
    }
}
