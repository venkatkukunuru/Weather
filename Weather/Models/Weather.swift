//
//  Weather.swift
//  Weather
//
//  Created by venkat kukunuru on 5/21/19.
//  Copyright © 2019 venkat kukunuru. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

struct Weather {
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    static func forecast (withLocation location:CLLocationCoordinate2D, city: String, completion: @escaping (WeatherModel) -> ()) {
        
        let url = ServiceConstant.basePath + ServiceConstant.api_key + "/" + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            if let data = data {
                do {
                    let weatherModel = try WeatherModel(json: JSON(data: data), cityName: city)
                    completion(weatherModel)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
}
