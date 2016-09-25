//
//  SecondCustomSegueUnwind.swift
//  Top Apps
//
//  Created by orlando arzola on 25.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class SecondCustomSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        
        //Animation 3
        
        secondVC?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! + 64)
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(secondVC!, belowSubview: firstVC!)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            // Animation 3
            
            firstVC?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            
        }) { (Finished) in
            
            
            UIView.animate(withDuration: 0.6, animations: {
                secondVC?.transform = CGAffineTransform.identity
                }, completion: { (Finished) in
                    
                    firstVC?.transform = CGAffineTransform.identity
                    
                    secondVC?.removeFromSuperview()
                    
                    if let navController = self.destination.navigationController {
                        
                        navController.popToViewController(self.destination, animated: false)
                    }
            })
            //self.source.navigationController?.pushViewController(self.destination, animated: false)
            
            
            
            
            //self.source.dismiss(animated: false, completion: nil)
        }
    }

}
