//
//  ViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    var image: UIImage?
    var summary = ""
    var category = ""
    var artist = ""
    var rights = ""
    var date = ""
    var appName = ""
    
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var appNameLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Details"
        
        
        self.navigationItem.hidesBackButton = true
        
        //.... Set Right/Left Bar Button item
        
        let leftBarButton = UIBarButtonItem(title: "< Top Apps", style: .done, target: self, action: #selector(ViewController.performSegueFromDetails))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        appImageView.image = image
        
        summaryTextView.text = summary
        categoryLabel.text = category
        artistLabel.text = artist
        rightsLabel.text = rights
        dateLabel.text = date
        appNameLable.text = appName
        
        animations()
        
    }
    
    
    func performSegueFromDetails () {
        
        performSegue(withIdentifier: "idSecondCustomSegueUnwind", sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // Circular ImageView
        appImageView.layer.cornerRadius = 15
        
        appImageView.layer.borderWidth = 1
        appImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        appImageView.clipsToBounds = true
        
        summaryTextView.layer.borderColor = UIColor.lightGray.cgColor
        summaryTextView.layer.borderWidth = 1
        
        summaryTextView.layer.cornerRadius = 10
    }
    
    func animations () {
        
        appImageView.alpha = 0
        
        summaryTextView.alpha = 0
        categoryLabel.alpha = 0
        artistLabel.alpha = 0
        rightsLabel.alpha = 0
        dateLabel.alpha = 0
        appNameLable.alpha = 0
        descriptionLabel.alpha = 0
        releaseDateLabel.alpha = 0
        
        UIView.animate(withDuration: 0.9, animations: {
            
            self.appImageView.alpha = 1
            
            self.summaryTextView.alpha = 1
            self.categoryLabel.alpha = 1
            self.artistLabel.alpha = 1
            self.rightsLabel.alpha = 1
            self.dateLabel.alpha = 1
            self.appNameLable.alpha = 1
            self.descriptionLabel.alpha = 1
            self.releaseDateLabel.alpha = 1
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

