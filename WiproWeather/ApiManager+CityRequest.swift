//
//  ApiManager+CityRequest.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import Foundation
import ObjectMapper

extension ApiManager {
    
    func getForecastFor(city:String,country:String,succesBlock: @escaping SuccesBlockAny,failureBlock: @escaping FailureBlock) {
        
        ApiManager.sharedInstance.basicAPICall(.get, complementaryParams: "\(city),\(country)", parameters: [:], succesBlock: { (response, string) in
            
            if let JSONString = String(data: response.data!, encoding: .utf8) {
                if let feed = Mapper<Forecast>().map(JSONString: JSONString) {
                    succesBlock(feed)
                }
            }
            else {
                failureBlock(ErrorReason.failedParsingJSON)
            }
        }) { (error) in
            #if DEBUG
                print("error in \(#file) \(#function) \n \(error)")
                failureBlock(error)
            #endif
        }
    }
    
}
