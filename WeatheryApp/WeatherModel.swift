//
//  CurrentWeatherModel.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import Foundation
import UIKit

class WeatherModel {
    var dataLoaded = false
    var apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&units=metric"
    var response: Dictionary<String, Any>!
    var city: String!
    var degrees: Double!
    var weatherType: String!
    var activityIndicator: UIActivityIndicatorView!
    var cityLabel: UILabel!
    var currentDegreesLabel: UILabel!
    var weatherIconImageView: UIImageView!
    
    init(lon: Double, lat: Double, indicator: UIActivityIndicatorView, currentDegreesLabel: UILabel, cityLabel: UILabel , weatherIconImageView: UIImageView) {
        print("Init weather")
        print(lon)
        print(lat)
        self.apiUrl = String.init(format: "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=cb62f472cb1c6e146b655bae93ba2b26&units=metric", lat, lon)
        print(apiUrl)
        activityIndicator = indicator
        self.cityLabel = cityLabel
        self.currentDegreesLabel = currentDegreesLabel
        self.weatherIconImageView = weatherIconImageView
        fetchUrl(url: self.apiUrl)
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
            self.city = self.response["name"] as? String;
            var responseMain: Dictionary<String, Any> = self.response["main"] as! Dictionary<String, Any>
            var responseWeather: [Dictionary<String, Any>] = self.response["weather"] as! [Dictionary<String, Any>]
            self.degrees = responseMain["temp"] as? Double;
            self.dataLoaded = true;
            print(self.city)
            print(self.degrees)
            self.activityIndicator.stopAnimating()
            self.currentDegreesLabel.text = String(format: "%i C", Int(self.degrees))
            self.cityLabel.text = self.city
            
            let icon = responseWeather[0]["icon"] as! String
            let url = URL(string: String(format: "https://openweathermap.org/img/w/%@.png", icon))
            print(url!)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                if let image = data {
                    DispatchQueue.main.async {
                        self.weatherIconImageView.image = UIImage(data: image)
                    }
                }
                
            }
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
}
