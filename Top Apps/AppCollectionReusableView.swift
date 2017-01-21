//
//  AppCollectionReusableView.swift
//  Top Apps
//
//  Created by orlando arzola on 21/01/2017.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AppCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var activityIndicator2: NVActivityIndicatorView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    override func layoutSubviews() {
        titleLabel.layer.cornerRadius = 8
        
        titleLabel.layer.borderColor = UIColor.white.cgColor
        titleLabel.layer.borderWidth = 2
        titleLabel.clipsToBounds = true
    }
        
}
