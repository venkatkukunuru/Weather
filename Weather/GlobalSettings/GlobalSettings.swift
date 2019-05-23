//
//  GlobalSettings.swift
//  Weather
//
//  Created by venkat kukunuru on 5/22/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation

struct GlobalConstant {
    
    struct Units {
        static let windSpeed = "km/hr"
        static let pressure = "hPa"
        static let visibility = "km"
        static let dewPoint = "°F"
    }
}

struct ServiceConstant {
    static let basePath = "https://api.darksky.net/forecast/"
    static let api_key = "422e4dd1601ba536d6d49546334d1c24"
}

struct ResponseKeys {
    
    struct Weather {
        static let summary = "summary"
        static let currently = "currently"
        static let hourly = "hourly"
        static let daily = "daily"
        static let data = "data"
    }
    
    struct WeatherOverview {
        static let city = "city"
        static let summary = "summary"
        static let temperature = "temperature"
        static let temperatureLow = "temperatureLow"
        static let temperatureHigh = "temperatureHigh"
        static let weekday = "weekday"
    }
    
    struct Hourly {
        static let time = "time"
        static let icon = "icon"
        static let temperature = "temperature"
    }
    
    struct Daily {
        static let time = "time"
        static let temperatureHigh = "temperatureHigh"
        static let temperatureLow = "temperatureLow"
        static let icon = "icon"
    }
    
    struct ExtendedInfo {
        static let sunriseTime = "sunriseTime"
        static let sunsetTime = "sunsetTime"
        static let humidity = "humidity"
        static let windSpeed = "windSpeed"
        static let pressure = "pressure"
        static let visibility = "visibility"
        static let uvIndex = "uvIndex"
        static let apparentTemperature = "apparentTemperature"
        static let dewPoint = "dewPoint"

    }
}
