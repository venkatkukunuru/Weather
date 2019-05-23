//
//  WeatherDaily.swift
//  Weather
//
//  Created by venkat kukunuru on 5/23/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct WeatherDaily {
    let day: String?
    let temperatureLow: Int?
    let temperatureHigh: Int?
    let description: UIImage?

    init(json: JSON) {
        let date = Date(timeIntervalSince1970: json[ResponseKeys.Daily.time].doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        self.day = dateFormatter.string(from: date)
        self.temperatureHigh = json[ResponseKeys.Daily.temperatureHigh].intValue
        self.temperatureLow = json[ResponseKeys.Daily.temperatureLow].intValue
        self.description = UIImage(named: json[ResponseKeys.Hourly.icon].stringValue)
    }
}
