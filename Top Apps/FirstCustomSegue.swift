//
//  FirstCustomSegue.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit


//Animation Slide In from Bottom

class FirstCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
    
        
        secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! - 2 * (secondVC?.center.y)!)
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(secondVC!, aboveSubview: firstVC!)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            
            
                secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! + 64)
                firstVC?.center = CGPoint(x: (firstVC?.center.x)!, y: 0 + 2 * (secondVC?.center.y)!)
            
            }) { (Finished) in
                
             
                
                self.source.navigationController?.pushViewController(self.destination, animated: false)
        }
    }

}
