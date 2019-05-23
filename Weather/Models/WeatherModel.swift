//
//  WeatherModel.swift
//  Weather
//
//  Created by venkat kukunuru on 5/23/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WeatherModel {
    var dailyArray: [WeatherDaily] = []
    let overview: WeatherOverview
    var hourlyArray: [WeatherHourly] = []
    let extendedInfo: WeatherExtendedInfo
        
    init(json: JSON, cityName: String) throws {
        
        guard let hourlyJson = json[ResponseKeys.Weather.hourly].dictionary else {
            throw NSError(domain: "weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON was not valid in Hourly."]) }

        guard let hourlyJsonArray = hourlyJson[ResponseKeys.Weather.data]?.array else {
            throw NSError(domain: "weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON was not valid in Hourly."]) }

        guard let dailyJson = json[ResponseKeys.Weather.daily].dictionary else {
            throw NSError(domain: "weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON was not valid in Daily."]) }

        guard let dailyJsonArray = dailyJson[ResponseKeys.Weather.data]?.array else {
            throw NSError(domain: "weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON was not valid in Daily."]) }

        for dataPoint in hourlyJsonArray {
            hourlyArray.append(WeatherHourly(json: dataPoint))
        }
        
        for x in 1..<dailyJsonArray.count {
            dailyArray.append(WeatherDaily(json: dailyJsonArray[x]))
        }
        
        extendedInfo = WeatherExtendedInfo(currentjson: json[ResponseKeys.Weather.currently], dailyjson: dailyJsonArray[0])

        overview = WeatherOverview(currentjson: json[ResponseKeys.Weather.currently], dailyjson: dailyJsonArray[0], city: cityName)
    }
}
