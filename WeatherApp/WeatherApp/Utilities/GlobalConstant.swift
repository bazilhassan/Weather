//
//  GlobalConstant.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/14/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import Foundation


//MARK:- URLS
let BASE_URL = "http://api.openweathermap.org/data/2.5/weather"


//KEY
let WEATHER_KEY = "95da089b9672e9612a9c4dc3fa282b72"


//MARK:- Enums

enum WeatherEnums: String {
    case clouds = "Clouds"
    case rain = "Rain"
    case haze  = "Haze"
    case clear  = "Clear"
    case smoke = "Smoke"
    
}

