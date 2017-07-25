//
//  ForecastCollectionViewCell.swift
//  WiproWeather
//
//  Created by Vlad-Constantin Buhaescu on 25/07/2017.
//  Copyright © 2017 Vlad-Constantin Buhaescu. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var rainDesc: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setupCell(dayForecast:DayForecast)  {
        
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
}
