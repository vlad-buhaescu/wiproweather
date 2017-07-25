//
//  ApiManager.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import Foundation

import UIKit

import Alamofire
import ObjectMapper

enum ErrorReason: Error {
    case noTokenPresent
    case failedParsingJSON
    case requestFailed(reason: String)
}

class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    
    fileprivate let baseURL = "http://default-environment-7p45veqn6g.elasticbeanstalk.com/api/"
    
    typealias SuccesBlock = (DataResponse<Any>, String?) -> Void
    typealias SuccesBlockAny = (AnyObject) -> Void
    typealias FailureBlock = (Error!) -> Void
    
    func basicAPICall(_ type: Alamofire.HTTPMethod, complementaryURL: String, parameters: Dictionary<String,String>, succesBlock: @escaping SuccesBlock, failureBlock: @escaping FailureBlock)    {
        
        let urlString: String = baseURL + complementaryURL as String
        
        let header = ["application":"x-www-form-urlencoded"]
        
        switch type {
        case .get:
            
            let dataRequest = Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header ).responseJSON { response in
                succesBlock(response, "succesful")
            }
            
            dataRequest.resume()
            
            break
        default:
            break
        }
    }
}

