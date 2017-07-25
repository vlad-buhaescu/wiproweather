//
//  DayWeather.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import ObjectMapper

class DayWeather: NSObject,Mappable {
    
    var main:String?
    var icon:String?
    
    public required init?(map: Map) {
    }
    // Mappable
    public func mapping(map: Map) {
        
        
    }
    
}
