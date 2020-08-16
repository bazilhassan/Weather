//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/14/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherModel : NSObject {
    
    var coord : Coordinates = Coordinates()
    var weathers: [Weather] = []
    var base:  String = ""
    var visibility:  Int = -1
    var dt:  Int = -1
    var timezone:  String = ""
    var id:  Int = -1
    var name : String = ""
    var code: Int = -1
    var main: WeatherMain = WeatherMain()
    var wind : WeatherWind = WeatherWind()
    var clouds : WeatherClouds = WeatherClouds()
    var weatherLocation: WeatherLocation = WeatherLocation()
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        coord = Coordinates(json: json["coord"])
        base = json["base"].stringValue
        visibility = json["visibility"].intValue
        dt = json["dt"].intValue
        timezone = json[timezone].stringValue
        id = json["id"].intValue
        name = json["name"].stringValue
        code = json["code"].intValue
        main = WeatherMain(json: json["main"])
        wind = WeatherWind(json: json["wind"])
        clouds = WeatherClouds(json: json["clouds"])
        weatherLocation = WeatherLocation(json: json["sys"])
        
        
        for weather in json["weather"].arrayValue {
            weathers.append(Weather(json: weather))
        }
    }
}

class Coordinates : NSObject {
    
    var lon : Double = -1
    var lat : Double = -1
    
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        lon = json["lon"].doubleValue
        lat = json["lat"].doubleValue
    }
}


class Weather : NSObject {
    
    var id : Int = -1
    var main : String = ""
    var descriptionWeather : String = ""
    var icon : String = ""
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        id = json["id"].intValue
        main = json["main"].stringValue
        descriptionWeather = json["description"].stringValue
        icon = json["icon"].stringValue
    }
}

class WeatherMain : NSObject {
    
    var temp : Double = -1
    var feels_like : Double = -1
    var temp_min : Double = -1
    var temp_max : Double = -1
    var pressure : Double = -1
    var humidity : Double = -1
    var sea_level : Double = -1
    var grnd_level : Double = -1
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        temp = json["temp"].doubleValue
        feels_like = json["feels_like"].doubleValue
        temp_min = json["temp_min"].doubleValue
        temp_max = json["temp_max"].doubleValue
        pressure = json["pressure"].doubleValue
        humidity = json["humidity"].doubleValue
        sea_level = json["sea_level"].doubleValue
        grnd_level = json["grnd_level"].doubleValue
    }
}

class WeatherWind : NSObject {
    
    var speed : Double = -1
    var deg : Double = -1
    
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        speed = json["speed"].doubleValue
        deg = json["deg"].doubleValue
    }
}

class WeatherClouds : NSObject {
    
    var all : Double = -1
    
    
    override init() {
        super.init()
    }
    
    
    init(json: JSON) {
        all = json["speed"].doubleValue
    }
}

class WeatherLocation : NSObject {
    
    var country : String = ""
    var sunrise : Double = -1
    var sunset : Double = -1
    
    override init() {
        super.init()
    }
    
    init(json: JSON) {
        country = json["speed"].stringValue
        sunrise = json["sunrise"].doubleValue
        sunset = json["sunset"].doubleValue
    }
}
