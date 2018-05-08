//
//  ViewController.swift
//  sun-state
//
//  Created by hell 'n silence on 5/8/18.
//  Copyright © 2018 Bohdan Podvirnyi. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = (self as GMSAutocompleteViewControllerDelegate)
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var long: UILabel!
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    let manager = CLLocationManager()
    var latitude: Double = 0
    var longitude: Double = 0
    var sunrise: String = ""
    var sunset: String = ""
    
    //MARK: - Getting user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        lat.text = String(describing: self.latitude)
        long.text = String(describing: self.longitude)
        
        Networking.shared.getTime(completion: { q in
            if !q {
                print("error")
            } else {
                self.dataArrived()
            }
        }, lat: latitude, long: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func dataArrived() {
        loading.stopAnimating()
        sunrise = UserDefaults.standard.string(forKey: "sunrise")!
        sunset = UserDefaults.standard.string(forKey: "sunset")!
        sunriseLabel.text = sunrise
        sunsetLabel.text = sunset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        loading.hidesWhenStopped = true
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.requestLocation()
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        UserDefaults.standard.set(place.name, forKey: "name")
        UserDefaults.standard.set(place.coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(place.coordinate.longitude, forKey: "longitude")
        
        let destination = storyboard?.instantiateViewController(withIdentifier: "details") as! PlaceViewController
        destination.name = place.name
        destination.latitude = place.coordinate.latitude
        destination.longitude = place.coordinate.longitude
        viewController.present(destination, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
