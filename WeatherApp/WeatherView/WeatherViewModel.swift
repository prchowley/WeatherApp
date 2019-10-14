//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation

final class WeatherViewModel {
    
    var completionRefresh: ()->() = {}
    
    var temperature: String = ""
    var weatherCondition: String = ""
    var humidity: String = ""
    var windSpeed: String = ""
    var windDegree: String = ""
    var iconName: String = ""
    var direction: String = ""
    
    func setup(with weatherAPI: API_Weather) {

        let kelvinConstant = 273.15
        
        let K = weatherAPI.main?.temp ?? 0.0
        let C =  K - kelvinConstant
        self.temperature = String(format: "%0.1f", C)
        
        self.windDegree = "\(weatherAPI.wind?.deg ?? 0)"
        self.direction = Double(weatherAPI.wind?.deg ?? 0).direction.description
        
//        let maxTemp = (weatherAPI.main?.tempMax ?? 0.0) - kelvinConstant
//        let minTemp = (weatherAPI.main?.tempMin ?? 0.0) - kelvinConstant
        self.weatherCondition = (weatherAPI.weather?.first?.main ?? "-")// + " \(maxTemp) / \(minTemp) °C"
        self.humidity = "\(weatherAPI.main?.humidity ?? 0) %"
        let windKmPH = String(format: "%0.1f", (weatherAPI.wind?.speed ?? 0.0) * 3.6)
        self.windSpeed = "\(self.direction) \(windKmPH) km/h"
        self.iconName = weatherAPI.weather?.first?.icon ?? ""
        
        self.completionRefresh()
        
        NotificationCenter.default.post(name: .weatherFetched, object: nil, userInfo: ["weather": self])
    }
    
    func getWeatherData(of latitude: Double, longitude: Double) {
        APIManager.shared.getWeatherData(for: "\(latitude)", longitude: "\(longitude)") { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let weather): weakSelf.setup(with: weather)
            case .failure(let error): print("Error\(error.localizedDescription)")
            }
        }
    }
}
