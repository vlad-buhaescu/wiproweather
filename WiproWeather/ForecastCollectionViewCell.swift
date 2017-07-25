//
//  ForecastCollectionViewCell.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit
import Alamofire

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var rainDesc: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var contentImageRequest: ImageRequest?
    var photosManager: PhotosManager { return .shared }
    var dayForecast:DayForecast?
    var iconName:String?
    
    func setupCell(dayForecast:DayForecast)  {
        self.dayForecast = dayForecast
        reset()
        loadImage()
        
        if let temp = dayForecast.main?.temp {
            tempLabel.text = "\(temp) ℃"
        }
        if let minTempC = dayForecast.main?.tempMin {
            minTemp.text = "\(minTempC) ℃"
        }
        if let maxTempC = dayForecast.main?.tempMax {
            maxTemp.text = "\(maxTempC) ℃"
        }
        if let rainDescS = dayForecast.weather?.first?.desc {
             rainDesc.text = "\(rainDescS)"
        }
        if let humidityS = dayForecast.main?.humidity {
            humidityLabel.text = "\(humidityS)%"
        }
        
    }
    
    func reset() {
        iconImageView.image = nil
        contentImageRequest?.cancel()
    }
    
    func loadImage() {
        
        guard let iconName = dayForecast?.weather?.first?.icon else {
            return
        }
        self.iconName = iconName
        if let image = photosManager.cachedImage(for: iconName) {
            populate(with: image)
            return
        }
        downloadImage()
    }
    
    func downloadImage() {
        
        if let iconNameL = self.iconName {
            contentImageRequest = photosManager.retrieveImage(for: iconNameL) { image in
                self.populate(with: image)
            }
        }
    }
    
    func populate(with image: UIImage) {
        
        DispatchQueue.main.async {
            self.iconImageView.image = image
          
        }
    }
    
    override func prepareForReuse() {
        self.iconImageView.image = nil
        self.contentImageRequest?.cancel()
    }
}
