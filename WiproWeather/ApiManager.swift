//
//  ApiManager.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

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
    
    let apiKey = "&appid=a10511bcb44d4c5cbdb8d57b3bca14a5"
    
    fileprivate let baseURL = "http://api.openweathermap.org/data/2.5/forecast?"
    fileprivate let modeFormat = "&mode=json&units=metric"
    //TODO: city from code
    
    fileprivate var requests = [Request]()
    
    typealias SuccesBlock = (DataResponse<Any>, String?) -> Void
    typealias SuccesBlockAny = (AnyObject) -> Void
    typealias FailureBlock = (Error!) -> Void
    
    func basicAPICall(_ type: Alamofire.HTTPMethod, complementaryParams: String, parameters: Dictionary<String,String>, succesBlock: @escaping SuccesBlock, failureBlock: @escaping FailureBlock)    {
        
        let urlString: String = baseURL + complementaryParams + modeFormat + apiKey as String
        
        switch type {
        case .get:
            
            let dataRequest = Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:] ).responseJSON { response in
                succesBlock(response, "succesful")
            }
            
            dataRequest.resume()
            
            requests.append(dataRequest)
            
            break
        default:
            break
        }
    }
    
    func cancelRequests() {
        if requests.count > 0 {
            for request in requests {
                request.cancel()
            }
        }
        requests.removeAll() //Delete all canceled requests
    }
}

