//
//  WeatherResult.swift
//  Weather App
//
//  Created by Jhoan Mauricio Vivas Rubiano on 18/05/20.
//  Copyright © 2020 Sennin. All rights reserved.
//

import Foundation

struct WeatherResult: Decodable {
    let main:Weather
}

struct Weather: Decodable {
    let temp:Double
    let humidity:Double
}

extension WeatherResult{
    static var emptyResult:WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}
