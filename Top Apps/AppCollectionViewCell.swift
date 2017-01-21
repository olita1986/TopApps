//
//  AppCollectionViewCell.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var numerLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        // Rounded ImageView
        appImageView.layer.cornerRadius = 15
        
        appImageView.layer.borderWidth = 1
        appImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        appImageView.clipsToBounds = true
        
        numerLabel.layer.cornerRadius = numerLabel.bounds.width / 2
        numerLabel.layer.borderWidth = 1
        numerLabel.layer.borderColor = UIColor.lightGray.cgColor
        numerLabel.clipsToBounds = true
    }
    
 
    
}
