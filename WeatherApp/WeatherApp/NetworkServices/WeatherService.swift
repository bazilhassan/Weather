//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/14/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class WeatherService: NSObject {
    
    static let sharedInstance : WeatherService = WeatherService()
    
    func getWeatherAPi(url : String , completion:  @escaping (_ success: Bool, _ message: String, _ weather : WeatherModel?)->Void) {
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            if response.error == nil {
                guard let data = response.data else {
                    completion(false , "", nil)
                    return
                }
                
                let json = JSON(data)
                print(json)
                let message = json["message"].stringValue
                let weather = WeatherModel(json: json)
                
                if json["coord"].exists() {
                    completion(true,  message, weather)
                } else {
                    completion(false, message, nil)
                }
            } else {
                completion(false, "Response Error", nil)
                debugPrint(response.error as Any)
            }
            
        }
        
    }
}
