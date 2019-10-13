//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 12/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import CoreLocation

typealias LocationManagerCompletion = (CLLocationCoordinate2D?)->()

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    var completion: LocationManagerCompletion?
    
    func getLocation(_ completion: @escaping LocationManagerCompletion) {
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.completion = completion
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func getPlaceName(from coordinate: CLLocationCoordinate2D, _ completion: @escaping (String)-> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude,
                                                       longitude: coordinate.longitude), preferredLocale: nil)
        { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let place = placemarks?.first else {
                print("No placemark from Apple: \(String(describing: error))")
                return
            }
            
            var addressString : String = ""
            if let subLocality = place.subLocality {
                addressString = addressString + subLocality
            }
            completion(addressString)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        completion?(locValue)
        self.locationManager.stopUpdatingLocation()
    }
}
