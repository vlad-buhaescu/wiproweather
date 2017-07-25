//
//  NSObject+Extension.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import Foundation

extension NSObject {
    
    func descriptionOfObject() -> String {
        
        var desc:String = ""
        let mirrored_object = Mirror(reflecting: self)
        desc = desc.appending("\n")
        for (index, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                if let value = attr.value as? String {
                    desc = desc.appending("\(index): \(property_name) = \(value) \n")
                }
                else {
                    
                    if "\(type(of: attr.value))" == "Optional<Picture>" {
                        let des = (attr.value as AnyObject).descriptionOfObject()
                        desc = desc.appending("\(index): \(property_name) = \(des) \n")
                    } else {
                        desc = desc.appending("\(index): \(property_name) = \(attr.value) \n")
                    }
                    
                }
            }
        }
        
        return desc
    }
    
}
