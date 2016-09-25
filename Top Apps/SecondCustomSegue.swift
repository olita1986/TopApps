//
//  SecondCustomSegue.swift
//  Top Apps
//
//  Created by orlando arzola on 25.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class SecondCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        
         let width = UIScreen.main.bounds.size.width
         let height = UIScreen.main.bounds.size.height
        
        //secondVC?.frame = CGRect(x: 0, y: height, width: width, height: height )
        
        secondVC?.frame = CGRect(x: 0, y: 64, width: 0, height: 0)
        
        let window = UIApplication.shared.keyWindow
        
        window?.insertSubview(secondVC!, aboveSubview: firstVC!)
        
        UIView.animate(withDuration: 0.6, animations: {
            
            // firstVC?.frame = CGRect(x: 0, y: -height , width: width, height: height)
            //secondVC?.frame = CGRect(x: 0, y: -height , width: width, height: height)
            
            secondVC?.frame = CGRect(x: 0, y: 64, width: width, height: height)
            
            
        }) { (Finished) in
            
            //self.source.present(self.destination as! AppsTableViewController, animated: true, completion: nil)
            
            self.source.navigationController?.pushViewController(self.destination, animated: false)
        }
    }

}
