//
//  FirstViewController.swift
//  WeatheryApp
//
//  Created by Eetu Kallio on 04/10/2018.
//  Copyright © 2018 Eetu Kallio. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var weather: WeatherModel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weather = WeatherModel(lon: appDelegate.location["longitude"]!, lat: appDelegate.location["latitude"]!)
    }


}

