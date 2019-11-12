//
//  Constants.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation

final class Constants {
    static let googleKey = "AIzaSyATR6-Ufi-cwPrKi0N1afC2aXwjRJBXGQ8"
    static let openWeatherAppID = "6ca218775e1d2b1b6a8ff71b2b5ea87a"
    static let openWeatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
}

extension Notification.Name {
    static let weatherFetched = Notification.Name("weatherFetched")
}
