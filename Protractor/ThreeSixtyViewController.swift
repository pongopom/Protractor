//
//  ThreeSixtyViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 04/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit
//import AVFoundation
class ThreeSixtyViewController: UIViewController {

    let nc = NSNotificationCenter.defaultCenter()
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var redTypeLabel: UILabel!
    @IBOutlet weak var blueTypeLabel: UILabel!
    @IBOutlet weak var scaleImageView: UIImageView!
    @IBOutlet weak var angleView: AngleView!
     var fingerRotation: OneFingerRotationGesture!
    
    //MARK: View Controller override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fingerRotation = OneFingerRotationGesture(midPoint: self.view.center, target: self, action: #selector(ThreeSixtyViewController.rotateGesture(_:)))
        self.view.addGestureRecognizer(self.fingerRotation)
        nc.addObserver(self, selector: #selector(ThreeSixtyViewController.updateTheUI), name: "UpdateTheUI", object: nil)
          nc.addObserver(self, selector: #selector(ThreeSixtyViewController.updateProtractorType), name: "UpdateProtractorType", object: nil)
        self.updateTheUI()
         self.updateProtractorType()
        self.angleReadOut = 270
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
   
    func updateTheUI(){
        print("time to update the UI")
        let hideScale = (self.userDefaults.valueForKey("HideScale") as! Bool)
        let hideAngle = (self.userDefaults.valueForKey("HideAngle") as! Bool)
        let hideAngleType = (self.userDefaults.valueForKey("HideAngleType") as! Bool)
        
        if (hideAngleType == true){
            self.redTypeLabel.hidden = true
            self.blueTypeLabel.hidden = true
        }
        else {
            if(hideScale == false){
                self.redTypeLabel.hidden = false
                self.blueTypeLabel.hidden = false
            }
            else{
                
                self.redTypeLabel.hidden = true
                self.blueTypeLabel.hidden = true
            }
        }
        
        if (hideScale == true){
            self.scaleImageView.hidden = true
        }
        else {
            self.scaleImageView.hidden = false
        }
        if (hideAngle == true){
            self.angleView.hidden = true
            self.redTypeLabel.hidden = true
            self.redLabel.hidden = true
            self.blueLabel.hidden = true
            self.blueTypeLabel.hidden = true
           self.fingerRotation.enabled = false
        }
        else {
            self.angleView.hidden = false
           // self.redTypeLabel.hidden = false
            self.redLabel.hidden = false
            self.blueLabel.hidden = false
          //  self.blueTypeLabel.hidden = false
            self.fingerRotation.enabled = true
            
            
            if (hideAngleType == true){
                self.blueTypeLabel.hidden = true
                self.redTypeLabel.hidden = true
            }
            else{
                self.blueTypeLabel.hidden = false
                self.redTypeLabel.hidden = false
            }
            
        }
    }
    
    var protractor: String!
    
    func updateProtractorType(){
        let protractorType = (self.userDefaults.valueForKey("ProtractorType") as! String)
        self.protractor = protractorType
        print("protractor type update")
        if (protractorType == "Per"){
            self.scaleImageView.image = UIImage(named: "per360")
            
        }
            
        else if (protractorType == "Rad"){
            self.scaleImageView.image = UIImage(named: "rad360")
        }
            
        else {
            self.scaleImageView.image = UIImage(named: "deg360")
            
        }
        self.updateProtractorLabels(Float(angleReadOut))
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
    
    
    var angleReadOut: CGFloat = 0.0{
        didSet {
            print("|angle is \(360 - angleReadOut )")
            angleView.setTheAngle(Float(angleReadOut))
            let angle2 = 360.0 - angleReadOut
            redTypeLabel.text = typeOfAngleFor(Float(angle2))
            blueTypeLabel.text = typeOfAngleFor(Float(angleReadOut * -1))
           // blueLabel.text = String(format:"%.0f%", Float(angleReadOut * -1)) + "˚"
           // redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
             self.updateProtractorLabels(Float(angleReadOut))
        }
    }
    
    
    func updateProtractorLabels(angle: Float){
        print("|angle is \(angle)")
        angleView.setTheAngle(angle)
        let angle2 = 360.0 - angle
        
        var anglev = Float(angleReadOut * -1)
        if anglev > -0.5{
            anglev = 0
        }
        
        
        let π = Float(M_PI)
       
        if (protractor == "Per"){
            blueLabel.text = String(format:"%.1f%", (Float(angle))/360*100) + "%"
            redLabel.text = String(format:"%.1f%", (Float(angle2))/360*100) + "%"
        }
            
        else if (protractor == "Rad"){
            blueLabel.text = ""
            redLabel.text = String(format:"%.2f%", (Float(angle2) * π/180.0)) + " rad"
        }
            
        else {
             blueLabel.text = String(format:"%.0f%", anglev) + "˚"
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
            
              //  print("|angle is \( angle.degrees )")
            
            //  self.view.layoutSubviews()
        }
        
        //        if let distance = recognizer.distance {
        //          //  feedbackLabel.text = feedbackLabel.text! + "\n" + String(format:"Distance: %.0f%", Float(distance))
        //        }
    }
    
}
