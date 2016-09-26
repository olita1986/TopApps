//
//  FirstCustomSegueUnwind.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class FirstCustomSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        
       
        
        secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! + 64)
        
      
        
        secondVC?.alpha = 0
        self.destination.navigationController?.navigationBar.alpha = 0
        
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(secondVC!, belowSubview: firstVC!)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            
            self.source.navigationController?.navigationBar.alpha = 0
            self.destination.navigationController?.navigationBar.alpha = 1
            secondVC?.alpha = 1
            firstVC?.alpha = 0
            
        }) { (Finished) in
            
           
            
            //self.source.navigationController?.pushViewController(self.destination, animated: false)
            
        
            secondVC?.removeFromSuperview()
            
            if let navController = self.destination.navigationController {
                
                navController.popToViewController(self.destination, animated: false)
            }
 
            
            //self.source.dismiss(animated: false, completion: nil)
        }
    }

}
