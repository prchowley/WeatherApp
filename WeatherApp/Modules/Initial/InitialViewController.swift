//
//  InitialViewController.swift
//  WeatherApp
//
//  Created by Priyabrata Chowley on 13/10/19.
//  Copyright © 2019 Priyabrata Chowley. All rights reserved.
//

import UIKit

final class InitialViewController: UIViewController {
    @IBOutlet weak var imageViewLogo: UIImageView! {
        didSet {
            imageViewLogo.layer.cornerRadius = 64
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.redirect()
    }
    
    /// User will be redireted to the Maps screen after 2 seconds, Placing here a delay because sometimes we need to do some processing or api call here,
    /// Implementing it here bacause the view transition does look good from this viewcontroller to the maps
    func redirect() {
        
//        DispatchQueue.main.async {
            self.navigationController?.hero.isEnabled = true
            self.navigationController?.hero.navigationAnimationType = .selectBy(presenting: .fade, dismissing: .fade)
            let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: "MapsViewController") as! MapsViewController
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
