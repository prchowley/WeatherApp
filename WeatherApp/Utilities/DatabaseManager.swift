//
//  DatabaseHelper.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import Foundation
import GooglePlaces
import MagicalRecord

final class DatabaseManager {
    
    class func setup() {
        MagicalRecord.setupCoreDataStack(withStoreNamed: "WeatherApp")
    }
    
    class func save(_ gmsPlace: GMSPlace) {
        MagicalRecord.save({ (context) in
            guard let placeId = gmsPlace.placeID else { return }
            let predicate = NSPredicate(format: "SELF.id ==[c] '%@'", placeId)
            let dbPlace = DB_Location.mr_findFirst(with: predicate, in: context) ?? DB_Location.mr_createEntity(in: context)
            dbPlace?.latitude = gmsPlace.coordinate.latitude
            dbPlace?.longitude = gmsPlace.coordinate.longitude
            dbPlace?.name = gmsPlace.formattedAddress
            dbPlace?.addedOn = Date()
            dbPlace?.id = placeId
        })
    }
    class func recentPlaces()-> [DB_Location] {
        return DB_Location.mr_findAllSorted(by: "addedOn", ascending: false) as? [DB_Location] ?? []
    }
}
