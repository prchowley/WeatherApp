//
//  MarkerView.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit

final class MarkerView: UIView {
    
    // MARK:- IBOutlets -
    @IBOutlet weak var labelTemperatureUnit: UILabel!
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    @IBOutlet private weak var imageViewCondition: UIImageView!
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var labelTemperature: UILabel!
    
    var refreshed: ()->() = {}
    
    // MARK:- Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MarkerView", owner: self, options: nil)
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        view.layoutIfNeeded()
        
        setup()
    }
    
    func setup() {
        self.loader.startAnimating()
        self.refreshView()
        NotificationCenter.default.removeObserver(self, name: .weatherFetched, object: nil)
        NotificationCenter.default.addObserver(forName: .weatherFetched, object: nil, queue: .main) { [weak self] (notification) in
            guard let weakSelf = self else { return }
            if let weather = notification.userInfo?["weather"] as? WeatherViewModel {
                weakSelf.loader.stopAnimating()
                weakSelf.labelTemperature.text = weather.temperature
                weakSelf.imageViewCondition.sd_setImage(with: URL(string: "https://openweathermap.org/img/w/\(weather.iconName).png")) { (_, _, _, _) in
                    weakSelf.refreshView()
                }
            }
        }
    }
    
    func refreshView() {
        self.labelTemperature.isHidden = self.loader.isAnimating
        self.labelTemperatureUnit.isHidden = self.loader.isAnimating
        self.imageViewCondition.isHidden = self.loader.isAnimating
        
        self.refreshed()
    }

}
