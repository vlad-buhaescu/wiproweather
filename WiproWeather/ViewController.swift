//
//  ViewController.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var wheatherDataService: WheatherDataService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = wheatherDataService
        self.collectionView.dataSource = wheatherDataService
        
        ApiManager.sharedInstance.getForecastFor(city: "London", country: "uk", succesBlock: { (response) in
            DispatchQueue.main.async {
                if let forecast = response as? Forecast {
                    self.wheatherDataService.dataSource = forecast
                    self.collectionView.reloadData()
                    print("wheater resp  \(forecast.descriptionOfObject())")
                    
                }
            }
            
            ApiManager.sharedInstance.cancelRequests()
            
            
        }) { (error) in
            print("error in \(#file) \(type(of: self)) \n \(error)")
        }
    }

}

