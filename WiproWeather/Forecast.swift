//
//  Forecast.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import ObjectMapper

class Forecast: NSObject,Mappable {
    
    var list:[DayForecast]?
    
    public required init?(map: Map) {
    }
    // Mappable
    public func mapping(map: Map) {
        
        list <- map["list"]
        
    }
    
}
