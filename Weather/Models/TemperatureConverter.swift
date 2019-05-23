//
//  TemperatureConverter.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation

struct TemperatureConverter {
    static func kelvinToCelsius(_ degrees: Double) -> Double {
        return round(degrees - 273.15)
    }
    
    static func kelvinToFahrenheit(_ degrees: Double) -> Double {
        return round(degrees * 9 / 5 - 459.67)
    }
}
