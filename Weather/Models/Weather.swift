//
//  Weather.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary: String
    let icon: String
    let temperature: Double
    let time: Double
    let tempMin : Double
    let tempMax : Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String: Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let time = json["time"] as? Double else {throw SerializationError.missing("time is missing")}

        if json.keys.contains("temperatureMax") {
            // contains key
            guard let tempMax = json["temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
            guard let tempMin = json["temperatureMin"] as? Double else {throw SerializationError.missing("temperature is missing")}
            self.temperature = 0
            self.tempMax = tempMax
            self.tempMin = tempMin
        } else {
            // does not contain key
            guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temperature is missing")}
            self.temperature = temperature
            self.tempMax = 0
            self.tempMin = 0
        }
        

        self.time = time
        self.summary = summary
        self.icon = icon
        
    }
    
    static let basePath = "https://api.darksky.net/forecast/"
    static let api_key = "422e4dd1601ba536d6d49546334d1c24"
    
    static func forecast (withLocation location:CLLocationCoordinate2D, city: String, completion: @escaping ([Weather], [Weather], String) -> ()) {
        
        let url = basePath + api_key + "/" + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var dailyArray:[Weather] = []
            var hourlyArray:[Weather] = []
            if let data = data {
                do {
                    if var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let hourlyForecasts = json["hourly"] as? [String:Any] {
                            if let hourlyData = hourlyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in hourlyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        hourlyArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                        
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        dailyArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                completion(hourlyArray, dailyArray, city)
            }
            
        }
        
        task.resume()
        
    }
    
}
