//
//  WeatherHourly.swift
//  Weather
//
//  Created by venkat kukunuru on 5/23/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct WeatherHourly {
    let hour: String?
    let temperature: Int?
    let description: UIImage?
    
    init(json: JSON) {
        let date = Date(timeIntervalSince1970: json[ResponseKeys.Hourly.time].doubleValue)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H a"

        self.hour = dateFormatter.string(from: date)
        self.temperature = json[ResponseKeys.Hourly.temperature].intValue
        self.description = UIImage(named: json[ResponseKeys.Hourly.icon].stringValue)
    }
}

