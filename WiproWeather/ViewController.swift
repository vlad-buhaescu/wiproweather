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
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var cityName:String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var wheatherDataService: WheatherDataService!
    @IBOutlet weak var newSearchButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.mapView.delegate = self
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 51.4967, longitude: -0.094)
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
        
        self.collectionView.delegate = wheatherDataService
        self.collectionView.dataSource = wheatherDataService
        self.getForecast(city: "London", isoCode: "uk")
        
        
        newSearchButtonOutlet.layer.cornerRadius = 15.0
        newSearchButtonOutlet.layer.masksToBounds = true
        newSearchButtonOutlet.isHidden = true
        
        
    }
    
    func getForecast(city:String,isoCode:String)  {
        
        ApiManager.sharedInstance.getForecastFor(city: city, country: isoCode, succesBlock: { (response) in
            DispatchQueue.main.async {
                if let forecast = response as? Forecast {
                    self.title = "\(city)"
                    self.newSearchButtonOutlet.isHidden = true
                    self.wheatherDataService.dataSource = forecast
                    self.collectionView.reloadData()
                    self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                      at: .left,
                                                      animated: true)
                }
            }
            
            ApiManager.sharedInstance.cancelRequests()
            
            
        }) { (error) in
            print("error in \(#file) \(type(of: self)) \n \(error)")
        }

    }
    
    func getISOCountryCode(locationParam:CLLocation,makeRequest:Bool)  {
        
        let geocoder = CLGeocoder.init()
        
        geocoder.reverseGeocodeLocation(locationParam) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error,makeRequest: makeRequest)
        }
        
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, makeRequest:Bool) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
        } else {
            
            if let placemarks = placemarks, let placemark = placemarks.first {
                
                if let city = placemark.locality {
                    self.title = city
                }
                
                if makeRequest {
                    self.getForecast(city: self.cityName!, isoCode: placemark.isoCountryCode!)
                }
            }
        }
    }
    
    //MARK: Buttons
    
    @IBAction func showSearchBar(_ sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    @IBAction func getWheatherHereAction(_ sender: UIButton) {
        
        self.getISOCountryCode(locationParam: CLLocation.init(latitude: self.mapView.centerCoordinate.latitude, longitude: self.mapView.centerCoordinate.longitude),makeRequest: false)
        
        ApiManager.sharedInstance.getForecastFor(latitude: "\(self.mapView.centerCoordinate.latitude)", longitude: "\(self.mapView.centerCoordinate.longitude)", succesBlock: { (response) in
            
            DispatchQueue.main.async {
                if let forecast = response as? Forecast {
                    self.newSearchButtonOutlet.isHidden = true
                    self.wheatherDataService.dataSource = forecast
                    self.collectionView.reloadData()
                    
                    if forecast.list?.count != 0 {
                        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                          at: .left,
                                                          animated: true)
                    }
                    
                    
                }
            }
            
            ApiManager.sharedInstance.cancelRequests()
        }) { (error) in
            print("error in \(#file) \(type(of: self)) \n \(error)")
        }
    }
}

//MARK: UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //1
        
        newSearchButtonOutlet.isHidden = true
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        self.cityName = searchBar.text
        
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            let location = CLLocation.init(latitude: (localSearchResponse?.boundingRegion.center.latitude)!, longitude: (localSearchResponse?.boundingRegion.center.longitude)!)
            self.getISOCountryCode(locationParam: location,makeRequest: true)
        }
    }

}


extension ViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        newSearchButtonOutlet.isHidden = false
    }
}

