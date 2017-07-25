//
//  Wind.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import ObjectMapper

class Wind: NSObject,Mappable {
    
    var speed:String?
    var deg:String?
    
    public required init?(map: Map) {
    }
    // Mappable
    public func mapping(map: Map) {
        
        speed <- map["speed"]
        deg <- map["deg"]
    }
    
}
