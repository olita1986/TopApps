//
//  DetailViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 25.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import ReachabilitySwift

class DetailViewController: UIViewController {
    
    var image: UIImage?
    var summary = ""
    var category = ""
    var artist = ""
    var rights = ""
    var date = ""
    var appName = ""
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Creating Custon Bar Button to perform custom segues
        
        self.navigationItem.hidesBackButton = true
        
        
        let leftBarButton = UIBarButtonItem(title: "< Top Apps", style: .done, target: self, action: #selector(DetailViewController.performSegueFromDetails))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        self.title = "Details"
        
        appImageView.image = image
        
        summaryTextView.text = summary
        categoryLabel.text = category
        artistLabel.text = artist
        rightsLabel.text = rights
        dateLabel.text = date
        appNameLabel.text = appName
        
        animations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppCollectionViewController.reachabilityChanged(note:)),name: ReachabilityChangedNotification,object: reachability)
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
    
    func performSegueFromDetails () {
        
        performSegue(withIdentifier: "idSecondCustomSegueUnwind", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        appNameLabel.alpha = 0
        descriptionLabel.alpha = 0
        releaseLabel.alpha = 0
        
        UIView.animate(withDuration: 0.9, animations: {
            
            self.appImageView.alpha = 1
            
            self.summaryTextView.alpha = 1
            self.categoryLabel.alpha = 1
            self.artistLabel.alpha = 1
            self.rightsLabel.alpha = 1
            self.dateLabel.alpha = 1
            self.appNameLabel.alpha = 1
            self.descriptionLabel.alpha = 1
            self.releaseLabel.alpha = 1
        })
    }
    
    // MARK: - Reachability for internet connection
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            
            
            //application.createAlert(title: "Oops!", message: "You don't have Internet connection!")
            
            self.perform(#selector(AppCollectionViewController.alert), with: nil, afterDelay: 1)
            
        }
    }
    
    func alert() {
        
        createAlert(title: "Opps!", message: "You don't have Internet connection!")
        
    }
    
    // Helper method for creating alerts
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
