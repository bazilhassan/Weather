//
//  StringExtension.swift
//  WeatherApp
//
//  Created by Hassan Qureshi on 8/15/20.
//  Copyright © 2020 hassan qureshi. All rights reserved.
//

import Foundation

extension String {
    func replaceSpaceChracter(with character: String)-> String {
        return replacingOccurrences(of: " " , with: character)
    }
}
