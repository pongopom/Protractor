//
//  OneEightyViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 04/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit

class OneEightyViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var keybutton: UIButton!
    @IBOutlet weak var lockButton: UIButton!

    let nc = NSNotificationCenter.defaultCenter()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("180 loaded")
        nc.addObserver(self, selector: "updateTheUI", name: "UpdateTheUI", object: nil)
        
        
         let center = CGPointMake(self.view.bounds.width/2 , self.view.bounds.height - 25)
        let ges = OneFingerRotationGesture(midPoint: center, target: self, action: "rotateGesture:")
       // self.view.addGestureRecognizer(OneFingerRotationGesture(midPoint: center, target: self, action: "rotateGesture:"))
        
       self.view.addGestureRecognizer(ges)
        ges.delegate = self
        self.updateTheUI()
    }
    
    
     let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func updateTheUI(){
      print("time to update the UI")
       let hideScale = (self.userDefaults.valueForKey("HideScale") as! Bool)
       let hideAngle = (self.userDefaults.valueForKey("HideAngle") as! Bool)
        // let hideScale = (self.userDefaults.valueForKey("HideScale") as! Bool)
            if (hideScale == true){
                self.scaleImageView.hidden = true
            }
            else {
                self.scaleImageView.hidden = false
        }
        if (hideAngle == true){
            self.angleView.hidden = true
        }
        else {
            self.angleView.hidden = false
        }
        
        
        
        
    }
    
    
    
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == self.lockButton
        || touch.view == self.keybutton{
            return false
        }
        
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        print("180 will appear")
         self.view.layoutSubviews()
    }
   
    
    //MARK: Handle rotation methods
    var currentValue:CGFloat = 0.0 {
        didSet {
            if (currentValue > 100) {
                currentValue = 100
            }
            if (currentValue < 0) {
                currentValue = 0
            }
        }
    }
    
    @IBOutlet weak var angleView: AngleView180!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var scaleImageView: UIImageView!
    
    
    var angleReadOut: CGFloat = 0.0{
        didSet {
         // angleReadOut = angleReadOut - 180
            if angleReadOut < 90.0 && angleReadOut >= 0 {
                angleReadOut = 360
            }
            
            if angleReadOut >= 90 && angleReadOut < 180 {
                angleReadOut = 180.0
            }
            
            print("|angle is \(angleReadOut)")
            
            
            angleView.setTheAngle(Float(angleReadOut))
            
              let angle2 = 360.0 - angleReadOut
            
              blueLabel.text = String(format:"%.0f%", Float(angleReadOut)) + "˚"
             redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
        }
    }
    
    
    
    
    func rotateGesture(recognizer:OneFingerRotationGesture)
    {
        
        // feedbackLabel.text = ""
        
        if let rotation = recognizer.rotation {
            currentValue += rotation.degrees / 360 * 100
            //  feedbackLabel.text = feedbackLabel.text! + String(format:"Value: %.2f%%", Float(currentValue))
        }
        
        if let angle = recognizer.angle {
            //  feedbackLabel.text = feedbackLabel.text! + "\n" + String(format:"Angle: %.2f%", Float(angle.degrees))
            self.angleReadOut = angle.degrees
            
            //    print("|angle is \(angle.degrees - 180)")
           // angleView.setTheAngle(Float(angle.degrees))
            //  self.view.layoutSubviews()
        }
        
        //        if let distance = recognizer.distance {
        //          //  feedbackLabel.text = feedbackLabel.text! + "\n" + String(format:"Distance: %.0f%", Float(distance))
        //        }
    }
    
    
    
}
