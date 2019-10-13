//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 12/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import GooglePlaces

enum VMCompletion {
    case loader(Bool)
    case success(Bool, String)
    case error(Bool, String)
}

final class SearchViewModel: NSObject {
    
    var completion: (VMCompletion)->() = {_ in}
    var arrLocations: [GMSAutocompletePrediction] = [] {
        didSet {
            self.completion(.success(false, ""))
        }
    }
    var strSearchKey: String = "" {
        didSet {
            let fetcher = GMSAutocompleteFetcher()
            fetcher.delegate = self
            fetcher.sourceTextHasChanged(strSearchKey)
            self.completion(.loader(true))
        }
    }
    var count: Int {
        return self.arrLocations.count
    }
    subscript(_ index: Int)-> GMSAutocompletePrediction {
        return self.arrLocations[index]
    }
    lazy var placeClient: GMSPlacesClient = {
        return GMSPlacesClient()
    }()
    let maxLatestRecentsCount: Int = 10
    lazy var recentsPlaces: [DB_Location] = {
        return DatabaseManager.recentPlaces()
    }()
    var countForRecents: Int {
        return recentsPlaces.count > maxLatestRecentsCount ? maxLatestRecentsCount : recentsPlaces.count
    }
    
    func getPlace(at indexPath: IndexPath, completionSelectedCity: ((GMSPlace)->())?) {
        
        let placeID = self[indexPath.row].placeID
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
        
        placeClient.fetchPlace(fromPlaceID: placeID, placeFields: fields, sessionToken: .init()) {
            (place: GMSPlace?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                return
            }
            if let place = place {
                DatabaseManager.save(place)
                completionSelectedCity?(place)
            }
        }
    }
    
}
extension SearchViewModel: GMSAutocompleteFetcherDelegate {
    func didFailAutocompleteWithError(_ error: Error) {
        print("Error \(error)")
        self.completion(.error(true, error.localizedDescription))
        self.completion(.loader(false))
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.arrLocations = predictions
        self.completion(.loader(false))
    }
}
