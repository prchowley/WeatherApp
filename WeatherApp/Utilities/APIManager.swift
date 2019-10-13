//
//  APIManager.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 12/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    
    var currentPlaceTask: DataRequest?
    func getWeatherData(for latitude: String, longitude: String, completion: @escaping (Result<API_Weather>)->()) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": "6ca218775e1d2b1b6a8ff71b2b5ea87a"
        ]
        currentPlaceTask?.cancel()
        currentPlaceTask = Alamofire.request(url, method: .get , parameters: parameters)
            .responseAPI_Weather { (response) in completion(response.result) }
            .responseString { (response) in print(response.result.value ?? "") }
    }
}
