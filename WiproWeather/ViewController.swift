//
//  ViewController.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ApiManager.sharedInstance.getForecastFor(city: "London", country: "uk", succesBlock: { (response) in
            print("wheater resp  \(response)")
        }) { (error) in
            print("error in \(#file) \(type(of: self)) \n \(error)")
        }
    }
    
    
}

