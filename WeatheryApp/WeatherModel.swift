//
//  CurrentWeatherModel.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import Foundation

class WeatherModel {
    var dataLoaded = false
    var apiUrl = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139"
    var response: Dictionary<String, Any>!
    
    init(lon: Double, lat: Double) {
        self.apiUrl = String.init(format: "http://api.openweathermap.org/data/2.5/weather?lat=%i&lon=%i&APPID=cb62f472cb1c6e146b655bae93ba2b26", Int(lat), Int(lon))
        print(apiUrl)
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
            self.dataLoaded = true;
            self.response = self.convertToDictionary(text: resstr!)
            NSLog(resstr!)
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
