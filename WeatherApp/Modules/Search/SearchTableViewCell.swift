//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit
import GooglePlaces

final class SearchLocationTableViewCell: UITableViewCell {
    
    // MARK:- Variables -
    var location: GMSAutocompletePrediction? {
        didSet {
            self.labelLocation.text = location?.attributedFullText.string ?? ""
        }
    }
    var dbLocation: DB_Location? {
        didSet {
            self.labelLocation.text = dbLocation?.name ?? ""
        }
    }
    
    // MARK:- IBOutlets -
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewBackLabel: UIView! {
        didSet {
            viewBackLabel.layer.cornerRadius = 6
            viewBackLabel.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1).cgColor
            viewBackLabel.layer.shadowOpacity = 1
            viewBackLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
            viewBackLabel.layer.shadowRadius = 5 / 2
            viewBackLabel.layer.shadowPath = nil
        }
    }
}
