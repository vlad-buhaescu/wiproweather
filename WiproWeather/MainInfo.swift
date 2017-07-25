//
//  MainInfo.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import ObjectMapper

class MainInfo: NSObject,Mappable {
    
    var temp:Float?
    var humidity:Float?
    var tempMin:Float?
    var tempMax:Float?
    
    public required init?(map: Map) {
    }
    // Mappable
    public func mapping(map: Map) {
        temp <- map["temp"]
        humidity <- map["humidity"]
        tempMin <- map["temp_min"]
        tempMax <- map["temp_max"]
    }
    
}
