//
//  ViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import ReachabilitySwift

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
        
        // Creating Custon Bar Button to perform custom segues
        
        self.navigationItem.hidesBackButton = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        
        NotificationCenter.default.post(name: ReachabilityChangedNotification, object: reachability)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // Reachability for internet connection
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            
            
            self.perform(#selector(ViewController.alert), with: nil, afterDelay: 1)
            
        }
    }
    
    func alert() {
        
        createAlert(title: "Opps!", message: "You don't have Internet connection!")
        
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
    
    // Helper method for creating alerts
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
   


}

