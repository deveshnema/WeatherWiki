//
//  WeatherWikiViewController.swift
//  WeatherWiki
//
//  Created by Devesh Nema on 5/2/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherWikiViewController: UIViewController, CLLocationManagerDelegate {
    //MARK: constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "4fa2335767fa080b4e2f83136f50e0b2"
    
    //MARK: properties
    let locationManager = CLLocationManager()
    
    
    //MARK: - Outlets
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    //MARK: Location Manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let params : [String : String] = ["lat" : String(latitude), "lon" : String(longitude), "appid" : APP_ID]

        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    

    
}
