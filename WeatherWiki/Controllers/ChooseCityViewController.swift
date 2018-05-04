//
//  ChooseCityViewController.swift
//  WeatherWiki
//
//  Created by Devesh Nema on 5/2/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredANewCityName(name: String)
}

class ChooseCityViewController: UIViewController {
    
    //MARK:- Delegate
    var delegate : ChangeCityDelegate?
    
    //MARK:- Outlets
    @IBOutlet weak var changeCityTextField: UITextField!
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let cityName = changeCityTextField.text {
            delegate?.userEnteredANewCityName(name: cityName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
