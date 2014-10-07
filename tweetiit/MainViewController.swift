//
//  MainViewController.swift
//  tweetiit
//
//  Created by Vidya Sridharan on 10/5/14.
//  Copyright (c) 2014 Vidya Sridharan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var panStartCoordinate: CGPoint!
    var menuViewController: UIViewController!
    var profileViewController: UIViewController!
    var homeViewController: UIViewController!
    
    var showingMenu: Bool?
    
    var direction = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name:"Main", bundle: nil)
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as UIViewController
        profileViewController  = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as UIViewController
        // Do any additional setup after loading the view.
        var panGestureRecognizer = UIPanGestureRecognizer (target: self, action: "onPan")
        panGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(panGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPan(gestureRecognizer: UIPanGestureRecognizer){
        var point = gestureRecognizer.locationInView(self.view)
        
        if(gestureRecognizer.state == UIGestureRecognizerState.Began){
            panStartCoordinate = point
        }
        else if (gestureRecognizer.state == UIGestureRecognizerState.Changed){
            var distance = point.x - panStartCoordinate.x
            if(distance > 0){
                direction = "R"
                var menuView = menuViewController.view
                self.view .sendSubviewToBack(menuView)
            }
            else{
                direction = "L"
                distance = 0
            }
            
            
            
         
        }
        else if (gestureRecognizer.state == UIGestureRecognizerState.Ended ){
            
            if(direction == "R"){
            
            }else{
            
            }
        
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
