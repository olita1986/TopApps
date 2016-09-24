//
//  AppsTableViewCell.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class AppsTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        // Circular ImageView
        appImageView.layer.cornerRadius = 15
        
        appImageView.layer.borderWidth = 1
        appImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        appImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     

}
