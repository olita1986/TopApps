//
//  MenuViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 19/01/2017.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import GuillotineMenu

class MenuViewController: UIViewController, GuillotineMenu {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mabeLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = "Activity"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
    }
    
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu2(_ sender: Any) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeMenu(_ sender: Any) {
        
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // Circular ImageView
        myImageView.layer.cornerRadius = myImageView.bounds.width / 2
        
        myImageView.layer.borderWidth = 1
        myImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        myImageView.clipsToBounds = true
        
 
    }
    
    func animations () {
        

        UIView.animate(withDuration: 0.9, animations: {
            
            self.myImageView.alpha = 1
            self.nameLabel.alpha = 1
            self.dateLabel.alpha = 1
            self.mabeLabel.alpha = 1

        })
    }

}

extension MenuViewController: GuillotineAnimationDelegate {
    
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        self.animations()
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
        
        self.myImageView.alpha = 0
        self.nameLabel.alpha = 0
        self.dateLabel.alpha = 0
        self.mabeLabel.alpha = 0
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
