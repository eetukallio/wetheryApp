//
//  SecondViewController.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var location: Dictionary = ["latitude": 15.1, "longitude": 30.1]
    let locationManager = CLLocationManager()
    var dataLoaded = false
    var apiUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=15&lon=30&unit=metric"
    var response: Dictionary<String, Any>!
    var forecasts: [Dictionary<String, Any>]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self;
        tableView.dataSource = self;
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }

    func loadForecast() -> Void {
        self.apiUrl = String.init(format: "https://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&APPID=cb62f472cb1c6e146b655bae93ba2b26&units=metric", self.location["latitude"]!, self.location["longitude"]!)
        fetchUrl(url:self.apiUrl);
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        print(data!.description)
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            self.response = self.convertToDictionary(text: resstr!)
            NSLog(resstr!)
            
            self.forecasts = self.response["list"] as? [Dictionary<String, Any>];
            
            self.dataLoaded = true;
            
            self.tableView.reloadData()
        })
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.location["latitude"] = locValue.latitude
        self.location["longitude"] = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
        loadForecast()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.forecasts != nil {
            return self.forecasts.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as? ForecastTableViewCell else {
            fatalError("Error with initializing cells.")
        }
        print("SETTING TABLE VIEW")
        let forecast = self.forecasts[indexPath.row]
        print(forecast.description)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm";
        let date = Date(timeIntervalSinceReferenceDate: forecast["dt"] as! Double)
        let formattedDate = formatter.string(from: date)
        cell.dayLabel.text = formattedDate;
        let weather = forecast["weather"] as! [Dictionary<String, Any>]
        cell.typeLabel.text = weather[0]["main"] as? String
        let main = forecast["main"] as! Dictionary<String, Any>
        let degrees = main["temp"] as! Double
        cell.degreesLabel.text = String(format: "%i C", Int(degrees))
        let icon = weather[0]["icon"] as! String
        let url = URL(string: String(format: "https://openweathermap.org/img/w/%@.png", icon))
        print(url!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            if let image = data {
                DispatchQueue.main.async {
                    cell.iconImageView.image = UIImage(data: image)
                }
            }
            
        }
        
        return cell;
    }
}

