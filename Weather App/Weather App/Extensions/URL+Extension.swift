//
//  URL+Extension.swift
//  Weather App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city:String) -> URL? {
        return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=21e48f906a5fad8263129cde0547c768&units=metric")
    }
}
