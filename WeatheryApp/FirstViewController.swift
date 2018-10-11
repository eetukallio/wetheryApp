//
//  FirstViewController.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate {
    
    var weather: WeatherModel!
    let locationManager = CLLocationManager()
    var location: Dictionary = ["latitude": 15.1, "longitude": 30.1]

    @IBOutlet weak var currentDegreesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        activityIndicator.hidesWhenStopped = true
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.location["latitude"] = locValue.latitude
        self.location["longitude"] = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
        getWeatherData()
    }
    
    func getWeatherData() -> Void {
        self.activityIndicator.startAnimating()
        self.weather = WeatherModel(lon: self.location["longitude"]!, lat: self.location["latitude"]!, indicator: activityIndicator, currentDegreesLabel: currentDegreesLabel, cityLabel: cityLabel)
       
      
        self.activityIndicator.stopAnimating()
        
    }
    
    

}

