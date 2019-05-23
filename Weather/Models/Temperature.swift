//
//  Temperature.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation

struct Temperature {
    let degrees: String
    
    init(country: String, openWeatherMapDegrees: Double) {
        if country == "US" {
            degrees = String(TemperatureConverter.kelvinToFahrenheit(openWeatherMapDegrees)) + "\u{f045}"
        } else {
            degrees = String(TemperatureConverter.kelvinToCelsius(openWeatherMapDegrees)) + "\u{f03c}"
        }
    }
}
