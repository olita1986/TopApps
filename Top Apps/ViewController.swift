//
//  ViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
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
        
    }
    
    func performSegueFromDetails () {
        
        performSegue(withIdentifier: "idSecondCustomSegueUnwind", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

