//
//  MapViewModel.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import CoreLocation

final class MapViewModel {
    
    /// Completion after fetching the location
    var completionLocationFetched: LocationManagerCompletion?
    
    /// If user's current location is active or not
    var isCurrentLocation: Bool = false
    
    /// Place name which user has selected or current location name
    var placeName: String = ""
    
    /// Fetching the location from the location manager on opening the page first time
    func getLocation() {
        LocationManager.shared.getLocation { [weak self] (userLocation) in
            DispatchQueue.main.async {
                guard let userLocation = userLocation else { return }
                guard let weakSelf = self else { return }
                LocationManager.shared.getPlaceName(from: userLocation) { (name) in
                    weakSelf.placeName = name
                    weakSelf.isCurrentLocation = true
                    weakSelf.completionLocationFetched?(userLocation)
                }
            }
        }
    }
}
