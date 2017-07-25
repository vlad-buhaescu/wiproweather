//
//  DayForecast.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import ObjectMapper

class DayForecast: NSObject,Mappable {
    
    var main:MainInfo?
    var weather:[DayWeather]?
    var wind:Wind?
    var rain:String?
    var time:String?
    
    
    public required init?(map: Map) {
    }
    // Mappable
    public func mapping(map: Map) {
        main <- map["main"]
        weather <- map["weather"]
        wind <- map["wind"]
//        rain <- map["KeyName"]
        time <- map["dt_txt"]
    }
    
}
