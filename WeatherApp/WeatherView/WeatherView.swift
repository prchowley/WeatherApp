//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 12/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit
import SDWebImage
import PureLayout

final class WeatherView: UIView {
    
    // MARK:- Variables -
    fileprivate lazy var objectViewModel: WeatherViewModel = {
        let viewModel = WeatherViewModel()
        viewModel.completionRefresh = { [weak self] in
            guard let weakSelf = self else { return }
            
            weakSelf.labelTemperature.text = weakSelf.objectViewModel.temperature
            weakSelf.labelHumidity.text = weakSelf.objectViewModel.humidity
            weakSelf.labelWindSpeed.text = weakSelf.objectViewModel.windSpeed
            weakSelf.labelWeatherCondition.text = weakSelf.objectViewModel.weatherCondition
            SDWebImageManager.shared.loadImage(with: URL(string: "https://openweathermap.org/img/w/\(weakSelf.objectViewModel.iconName).png"),
                                               options: .progressiveLoad, progress: nil) { (image, _, _, _, _, _) in
                                                
                                                weakSelf.imageViewWeatherCondition.image = image
                                                
                                                weakSelf.imageViewWeatherCondition.backgroundColor = .white
                                                weakSelf.imageViewWeatherCondition.layer.cornerRadius = 6
                                                weakSelf.imageViewWeatherCondition.layer.shadowColor = UIColor.darkGray.cgColor
                                                weakSelf.imageViewWeatherCondition.layer.shadowOpacity = 1
                                                weakSelf.imageViewWeatherCondition.layer.shadowOffset = CGSize(width: 0, height: 2)
                                                weakSelf.imageViewWeatherCondition.layer.shadowRadius = 5 / 2
                                                weakSelf.imageViewWeatherCondition.layer.shadowPath = nil

            }
        }
        return viewModel
    }()
    
    // MARK:- IBOutlets -
    @IBOutlet private weak var imageViewWeatherCondition: UIImageView!
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var labelWeatherCondition: UILabel!
    @IBOutlet private weak var labelHumidity: UILabel!
    @IBOutlet private weak var labelWindSpeed: UILabel!
    @IBOutlet private weak var labelTemperatureUnit: UILabel!
    @IBOutlet private weak var labelTemperature: UILabel!
    @IBOutlet private weak var constHeightBottomView: NSLayoutConstraint!

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

        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        view.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.layer.shadowColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.047).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: -5)
        view.layer.shadowRadius = 8 / 2
        view.layer.shadowPath = nil

        view.roundCorners([.topLeft, .topRight] , radius: 8)

    }
    // MARK:- Data -
    func refresh(with latitude: Double, longitude: Double) {
        self.objectViewModel.getWeatherData(of: latitude, longitude: longitude)
    }
}
