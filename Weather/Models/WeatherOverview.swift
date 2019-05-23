//
//  WeatherOverview.swift
//  Weather
//
//  Created by venkat kukunuru on 5/22/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct WeatherOverview {
    let shortDescription: String?
    let currentTemperature: Int?
    let temperatureLow: Int?
    let temperatureHigh: Int?
    let weekDay: String?
    let city: String?

    init(currentjson: JSON, dailyjson: JSON, city: String) {
        self.city = city
        self.shortDescription = currentjson[ResponseKeys.WeatherOverview.summary].stringValue
        self.currentTemperature = currentjson[ResponseKeys.WeatherOverview.temperature].intValue
        self.temperatureLow = dailyjson[ResponseKeys.WeatherOverview.temperatureLow].intValue
        self.temperatureHigh = dailyjson[ResponseKeys.WeatherOverview.temperatureHigh].intValue
     
        let date = Date(timeIntervalSince1970: dailyjson[ResponseKeys.Daily.time].doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        self.weekDay = dateFormatter.string(from: date)

    }
}
