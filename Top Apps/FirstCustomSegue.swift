//
//  FirstCustomSegue.swift
//  Top Apps
//
//  Created by orlando arzola on 23.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class FirstCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        
       // let width = UIScreen.main.bounds.size.width
       // let height = UIScreen.main.bounds.size.height
        
        //secondVC?.frame = CGRect(x: 0, y: height, width: width, height: height )
        
        secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! - 2 * (secondVC?.center.y)!)
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(secondVC!, aboveSubview: firstVC!)
        
        UIView.animate(withDuration: 0.6, animations: {
            
               // firstVC?.frame = CGRect(x: 0, y: -height , width: width, height: height)
                //secondVC?.frame = CGRect(x: 0, y: -height , width: width, height: height)
            
                secondVC?.center = CGPoint(x: (firstVC?.center.x)!, y: (firstVC?.center.y)! + 64)
                firstVC?.center = CGPoint(x: (firstVC?.center.x)!, y: 0 + 2 * (secondVC?.center.y)!)
            
            }) { (Finished) in
                
                //self.source.present(self.destination as! AppsTableViewController, animated: true, completion: nil)
                
                self.source.navigationController?.pushViewController(self.destination, animated: false)
        }
    }

}
