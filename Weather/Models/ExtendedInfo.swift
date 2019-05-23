//
//  WeatherExtendedInfo.swift
//  Weather
//
//  Created by venkat kukunuru on 5/23/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

enum ExtendedInfo: String {
    case sunrise, sunset, humidity, wind, feelLike, dewPoint, pressure, visibility, uvIndex
    
    var stringValue: String {
        var textString = ""
        switch self {
        case .uvIndex:
            textString = "UV INDEX"
        case .feelLike:
            textString = "FEEL LIKE"
        case .dewPoint:
            textString = "DEW POINT"
        default:
            textString = self.rawValue.uppercased()
        }
        return "\(textString) :  "
    }
}

struct WeatherExtendedInfo {
    
    let sunriseTime: String?
    let sunsetTime: String?
    
    var humidity: Float = 0
    
    var feelLikeTemperature: Int = 0
    var dewPoint: Int = 0
    
    var windSpeed: Int = 0
    var pressure: Int = 0
    
    var visibility: Float = 0
    var uvIndex: Int = 0
    
    init(currentjson: JSON, dailyjson: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"

        let date = Date(timeIntervalSince1970: dailyjson[ResponseKeys.ExtendedInfo.sunriseTime].doubleValue)
        self.sunriseTime = dateFormatter.string(from: date)
        
        let date1 = Date(timeIntervalSince1970: dailyjson[ResponseKeys.ExtendedInfo.sunsetTime].doubleValue)
        self.sunsetTime = dateFormatter.string(from: date1)

        self.feelLikeTemperature = currentjson[ResponseKeys.ExtendedInfo.apparentTemperature].intValue
        self.dewPoint = currentjson[ResponseKeys.ExtendedInfo.dewPoint].intValue
        self.humidity = currentjson[ResponseKeys.ExtendedInfo.humidity].floatValue
        self.windSpeed = currentjson[ResponseKeys.ExtendedInfo.windSpeed].intValue
        self.pressure = currentjson[ResponseKeys.ExtendedInfo.pressure].intValue
        self.visibility = currentjson[ResponseKeys.ExtendedInfo.visibility].floatValue
        self.uvIndex = currentjson[ResponseKeys.ExtendedInfo.uvIndex].intValue
    }
}
