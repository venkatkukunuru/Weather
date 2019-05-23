//
//  ExtendedInfoViewModel.swift
//  Weather
//
//  Created by venkat kukunuru on 5/23/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation

struct WeatherExtendedInfoViewModel: WeatherFormatable {
    
    private var info: WeatherExtendedInfo
    init(weatherExtendedInfo: WeatherExtendedInfo) {
        self.info = weatherExtendedInfo
    }
    
    func setupString(key: ExtendedInfo) -> String {
        switch key {
        case .sunrise:
            return info.sunriseTime ?? ""
        case .sunset:
            return info.sunsetTime ?? ""
        case .humidity:
            return floatToPercentageString(float: info.humidity)
        case .wind:
            return addUnit(GlobalConstant.Units.windSpeed, toNumber: info.windSpeed)
        case .feelLike:
            return addDegreeSign(toNumber: "\(info.feelLikeTemperature)")
        case .dewPoint:
            return addUnit(GlobalConstant.Units.dewPoint, toNumber: info.dewPoint)
        case .pressure:
            return addUnit(GlobalConstant.Units.pressure, toNumber: info.pressure)
        case .visibility:
            return addUnit(GlobalConstant.Units.visibility, toNumber: info.visibility)
        case .uvIndex:
            return "\(info.uvIndex)"
        }
    }
}
