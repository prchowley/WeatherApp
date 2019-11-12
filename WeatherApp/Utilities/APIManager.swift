//
//  APIManager.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import Alamofire

final class APIManager {
    
    static let shared = APIManager()
    
    var currentPlaceTask: DataRequest?
    func getWeatherData(for latitude: String, longitude: String, completion: @escaping (Result<API_Weather>)->()) {
        let parameters = [
            "lat": latitude,
            "lon": longitude,
            "appid": Constants.openWeatherAppID
        ]
        currentPlaceTask?.cancel()
        currentPlaceTask = Alamofire.request(Constants.openWeatherBaseURL, method: .get , parameters: parameters)
            .responseAPI_Weather { (response) in completion(response.result) }
            .responseString { (response) in print(response.result.value ?? "") }
    }
}
