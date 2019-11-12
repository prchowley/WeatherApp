//
//  MapsViewController.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit
import Hero
import GoogleMaps
import GooglePlaces

final class MapsViewController: UIViewController {
    
    // MARK:- Variables -

    /// View Model for this controller's view
    var objectViewModel: MapViewModel = .init()
    
    // MARK:- IBOutlets
    @IBOutlet weak var buttonGPS: UIButton! {
        didSet {
            self.buttonGPS.addControlEvent(.touchUpInside) {
                self.marker.tracksViewChanges = true
                self.objectViewModel.getLocation()
            }
        }
    }
    
    /// Bottom constraint for the weather view
    @IBOutlet weak var constBottomViewDrag: NSLayoutConstraint! {
        didSet {
            self.constBottomViewDrag.constant = -200
        }
    }
    
    /// Weather VIew, on which weather values are getting displayed
    @IBOutlet weak var viewWeather: WeatherView!
    
    /// Google Map View
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            self.mapView.settings.scrollGestures = false
            self.mapView.delegate = self
        }
    }
    
    /// Back view of search field which is animating on clicking on the search field to next controller
    @IBOutlet weak var viewAnimationPlaceholder: UIView! {
        didSet {
            viewAnimationPlaceholder.layer.cornerRadius = 6
            viewAnimationPlaceholder.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.02).cgColor
            viewAnimationPlaceholder.layer.shadowOpacity = 1
            viewAnimationPlaceholder.layer.shadowOffset = CGSize(width: 0, height: 2)
            viewAnimationPlaceholder.layer.shadowRadius = 5 / 2
            viewAnimationPlaceholder.layer.shadowPath = nil
        }
    }
    
    /// Search text field for searching locations
    @IBOutlet weak var textFieldSearch: UITextField! {
        didSet {
            self.textFieldSearch.delegate = self
        }
    }
    
    /// Back view for Search TextField
    @IBOutlet weak var viewBackSearchField: UIView!
    
    /// A view to drag the bottom pane
    @IBOutlet weak var viewDrag: UIView! {
        didSet {
            self.viewDrag.backgroundColor = .clear
        }
    }
    
    
    /// Setting up function which will get the first launch location and set up completion for the viewmodel
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objectViewModel.getLocation()
        self.objectViewModel.completionLocationFetched = { [weak self] coordinate in
            guard let weakSelf = self else { return }
            guard let coordinate = coordinate else { return }
            weakSelf.updateUI(with: coordinate)
        }
    }
    
    /// When ever a new coordinate detected by location manager or user selection this will update the view
    /// - Parameter coordinate: the latest coordinate of which view needs to render itself
    func updateUI(with coordinate: CLLocationCoordinate2D) {
        
        self.textFieldSearch.text = self.objectViewModel.placeName
        
        self.updateMapCamera(to: coordinate)
        self.viewWeather.refresh(with: coordinate.latitude, longitude: coordinate.longitude)
        
        self.buttonGPS.tintColor = self.objectViewModel.isCurrentLocation ? UIColor(red:0.21, green:0.60, blue:0.91, alpha:1.0) : .darkGray
    }
    
    /// Map marker which will be visible on each selection on the search field
    lazy var marker: GMSMarker = {
        let customMarkerView = MarkerView(frame: .init(x: 0, y: 0, width: 100, height: 60))
        let marker = GMSMarker()
        marker.appearAnimation = .pop
        marker.map = self.mapView
        marker.iconView = customMarkerView
        marker.tracksViewChanges = true
        customMarkerView.refreshed = {
            marker.tracksViewChanges = true
        }
        
        return marker
    }()
    
    
    /// This will place the marker on the mapview with animation
    /// - Parameter coordinate: on which coordinate the marker needs to display
    func placeMarker(to coordinate: CLLocationCoordinate2D) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        self.marker.position = coordinate
        CATransaction.commit()
    }
    
    /// This will update the camera position of the map with latest coordinate
    /// - Parameter coordinate: user's selected coordinate or my location for the first time
    func updateMapCamera(to coordinate: CLLocationCoordinate2D) {
        
        self.mapsAnimationCompletion(animations: {
            self.mapView.animate(toZoom: 5);
        }) {
            self.mapsAnimationCompletion(animations: {
                self.mapView.animate(to: .init(target: coordinate, zoom: 5))
            }) {
                self.mapView.animate(toZoom: 15);
                self.placeMarker(to: coordinate)
            }
        }
    }
    
    private func mapsAnimationCompletion(animations: () -> Void, completion: (() -> Void)!) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        animations()
        CATransaction.commit()
    }
    
    
    /// This will toggle bottom weather view after user taps on the marker
    func toggleBottomView() {
        self.constBottomViewDrag.constant == 0 ? hideBottomView() : showBottomView()
    }
    
    /// This will show the bottom weather view after user taps on the marker
    func showBottomView() {
        self.constBottomViewDrag.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.viewDrag.layoutIfNeeded()
        }
    }
    
    
    /// This will hide the bottom window, if user taps on outside or every second tap on the marker closing the window
    func hideBottomView() {
        self.constBottomViewDrag.constant = -200
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// when user taps on the top search field this func gets called
    /// - If user taps on the search field, we need to redirect to a search controller where user can search for any location,
    ///   After user selects a new city from the list, we need to refresh the view based on that location by user 'updateUI()' function here
    func openSearchController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        vc.hero.isEnabled = true
        vc.delegate = self
        vc.textFieldValue = self.objectViewModel.placeName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MapsViewController: SearchViewControllerDelegate {
    func select(_ place: GMSPlace) {
        marker.tracksViewChanges = true
        self.objectViewModel.isCurrentLocation = false
        self.objectViewModel.placeName = place.formattedAddress ?? ""
        self.updateUI(with: place.coordinate)
    }
    func select(_ recent: DB_Location) {
        marker.tracksViewChanges = true
        self.objectViewModel.isCurrentLocation = false
        self.objectViewModel.placeName = recent.name ?? ""
        self.updateUI(with: CLLocationCoordinate2D(latitude: recent.latitude, longitude: recent.longitude))
    }
}

// MARK:- UITextFieldDelegate -
extension MapsViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.hideBottomView()
        self.openSearchController()
        return false
    }
}

// MARK:- GMSMapViewDelegate -
extension MapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        toggleBottomView()
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        hideBottomView()
    }
}
