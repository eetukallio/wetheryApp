//
//  CurrentWeatherModel.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import Foundation

class WeatherModel {
    var dataLoaded = false;
    var id: Int!
    var main: String!
    var description: String!
    var icon: String!
    
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            self.dataLoaded = true;
            NSLog(resstr!)
        })
    }
}
