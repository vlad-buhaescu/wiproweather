//
//  PhotoManager.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
}

class PhotosManager {
    
    static let shared = PhotosManager()
    
    var imagesStack:[ImagePersistence] = []
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(200).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(120).megabytes()
    )
    
    let decodeQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = DispatchQueue(label: "home.PocketVU1", attributes: .concurrent)
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    
    //MARK: - Image Downloading
    
    func retrieveImage(for url: String, completion: @escaping (UIImage) -> Void) -> ImageRequest {
        
        let queue = decodeQueue.underlyingQueue
        let request = Alamofire.request(url, method: .get)
        let imageRequest = ImageRequest(request: request)
        let serializer = DataRequest.imageResponseSerializer()
        imageRequest.request.response(queue: queue, responseSerializer: serializer) { response in
            guard let image = response.result.value else { return }
            imageRequest.decodeOperation = self.decode(image) { image in
                completion(image)
                
                if self.imagesStack.getImagePersistanceForUrl(url: url) == nil {
                    let imagePersistance = ImagePersistence()
                    imagePersistance.image = image
                    imagePersistance.url = url
                    self.imagesStack.append(imagePersistance)
                }
                
                self.cache(image, for: url)
            }
        }
        
        
        return imageRequest
    }
    
    
    
    func generateReq(url:String,completion: @escaping (UIImage) -> Void)  -> Request  {
        
        return Alamofire.request(url, method: .get).responseImage { response in
            guard let image = response.result.value else { return }
            completion(image)
            self.cache(image, for: url)
        }
    }
    
    //MARK: - Image Caching
    
    func cache(_ image: Image, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> Image? {
        
        if let image = self.imagesStack.getImagePersistanceForUrl(url: url) {
            return image
        }
        
        return imageCache.image(withIdentifier: url)
    }
    
    //MARK: - Image Decoding
    
    func decode(_ image: UIImage, completion: @escaping (UIImage) -> Void) -> DecodeOperation {
        let operation = DecodeOperation(image: image, completion: completion)
        decodeQueue.addOperation(operation)
        return operation
    }
}
