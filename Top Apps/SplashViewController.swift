//
//  SplashViewController.swift
//  Top Apps
//
//  Created by orlando arzola on 22/01/2017.
//  Copyright © 2017 orlando arzola. All rights reserved.
//

import UIKit
import IBAnimatable

class SplashViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var logoImageView: AnimatableImageView!
    
    @IBOutlet weak var starIV1: AnimatableImageView!
    @IBOutlet weak var starIV2: AnimatableImageView!
    
    @IBOutlet weak var starIV3: AnimatableImageView!
    
    @IBOutlet weak var starIV4: AnimatableImageView!
    
    @IBOutlet weak var starIV5: AnimatableImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        starIV1.isHidden = true
        starIV2.isHidden = true
        starIV3.isHidden = true
        starIV4.isHidden = true
        starIV5.isHidden = true
        // Do any additional setup after loading the view.
        setUpAnimations()
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpAnimations () {
        
        // Setup the animation
        logoImageView.damping = 0.5
        logoImageView.velocity = 2
        logoImageView.force = 1
        
        starIV1.damping = 0.5
        starIV1.duration = 0.2
        starIV1.velocity = 2
        starIV1.force = 1
        
        starIV2.damping = 0.5
        starIV2.duration = 0.2
        starIV2.velocity = 2
        starIV2.force = 1
    
        starIV3.damping = 0.5
        starIV3.duration = 0.2
        starIV3.velocity = 2
        starIV3.force = 1
        
        starIV4.damping = 0.5
        starIV4.duration = 0.2
        starIV4.velocity = 2
        starIV4.force = 1
        
        starIV5.damping = 0.5
        starIV5.duration = 0.2
        starIV5.velocity = 2
        starIV5.force = 1
        
        
        logoImageView.pop(repeatCount: 1) {
            
            self.logoImageView.rotate(direction: .ccw, repeatCount: 1, completion: {
                
                self.logoImageView.flip(axis: .y, completion: { 
                    
                    
                    self.starIV1.isHidden = false
                    
                    self.starIV1.pop(repeatCount: 1, completion: {
                        
                        self.starIV2.isHidden = false
                        
                        self.starIV2.pop(repeatCount: 1, completion: {
                            
                            self.starIV3.isHidden = false
                            
                            self.starIV3.pop(repeatCount: 1, completion: {
                                
                                self.starIV4.isHidden = false
                                
                                self.starIV4.pop(repeatCount: 1, completion: {
                                    
                                    self.starIV5.isHidden = false
                                    
                                    self.starIV5.pop(repeatCount: 1, completion: {
                                        
                                          self.presentMainView()
                                    })
                                    
                                    self.starIV5.animate()
                                })
                                
                                self.starIV4.animate()
                            })
                            
                            self.starIV3.animate()
                        })
                        
                        self.starIV2.animate()
                    })
                    
                    self.starIV1.animate()
                })
               
            })
        }
        
        // Start the animation
        logoImageView.animate()
        
        
        
    }
    
    func presentMainView () {
        
        let animation = CATransition()
        animation.delegate = self
        animation.type = kCATransitionFade
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        var storyBoard = UIStoryboard()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            storyBoard = UIStoryboard(name: "iPadMain", bundle: nil)
            
        } else {
            
            storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
        }
        
        let homeVC = storyBoard.instantiateViewController(withIdentifier: "mainVC")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.layer.add(animation, forKey: "transitionViewAnimation")
        
        appDelegate.window?.rootViewController = homeVC
        
        appDelegate.window?.makeKeyAndVisible()
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
