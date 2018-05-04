//
//  WeatherWikiViewController.swift
//  WeatherWiki
//
//  Created by Devesh Nema on 5/2/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SDWebImage


class WeatherWikiViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    //MARK: Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let WIKI_URL = "https://en.wikipedia.org/w/api.php"
    let APP_ID = "4fa2335767fa080b4e2f83136f50e0b2"
    
    //MARK: Properties
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    
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

    //MARK: - Get weather data
    func getWeatherData(url: String, parameters : [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error getting weather data")
            }
        }
    }
    
    func getWikiData(cityName: String) {
        let params : [String : String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "pageimages",
            "titles" : cityName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "800"
        ]
        
        Alamofire.request(WIKI_URL, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let wikiJson : JSON = JSON(response.result.value!)
                let pageid = wikiJson["query"]["pageids"][0].stringValue
                let imageUrl = wikiJson["query"]["pages"][pageid]["thumbnail"]["source"].stringValue
                self.cityImage.sd_setImage(with: URL(string: imageUrl))
            } else {
                print("Error getting Wikipedia Image")
            }
        }
    }
    
    //MARK: - Update weather data
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.getWeatherIconName(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - Update UI with weather data
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature) °"
        weatherImage.image = UIImage(named: weatherDataModel.weatherIconName)
        getWikiData(cityName: weatherDataModel.city)
    }

    //MARK: - Location Manager Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let params : [String : String] = ["lat" : String(latitude), "lon" : String(longitude), "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    //MARK:- delegate methods
    func userEnteredANewCityName(name: String) {
        let params : [String : String] = ["q" : name, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCity" {
            let destinationVC = segue.destination as! ChooseCityViewController
            destinationVC.delegate = self
        }
    }
    
}
