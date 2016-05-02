//
//  OneEightyViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 04/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit

class OneEightyViewController: UIViewController {
  
    let nc = NSNotificationCenter.defaultCenter()
    var fingerRotation: OneFingerRotationGesture!
   // var proType:String = ""
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
       //  self.scaleImageView.image = UIImage(named: "180Iscale")
      //  self.updateProtractorType()
        
        print("180 loaded")
       //  let protractorType = (self.userDefaults.valueForKey("ProtractorType") as! String)
     //   self.proType = protractorType
        nc.addObserver(self, selector: #selector(OneEightyViewController.updateTheUI), name: "UpdateTheUI", object: nil)
        nc.addObserver(self, selector: #selector(OneEightyViewController.updateProtractorType), name: "UpdateProtractorType", object: nil)
        
        
        let center = CGPointMake(self.view.bounds.width/2 , self.view.bounds.height - 25)
        self.fingerRotation = OneFingerRotationGesture(midPoint: center, target: self, action: #selector(OneEightyViewController.rotateGesture(_:)))
        self.view.addGestureRecognizer(self.fingerRotation)
        self.updateTheUI()
        self.updateProtractorType()
        self.angleReadOut = 270
    }
    
     let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func updateTheUI(){
      print("time to update the UI")
        // self.scaleImageView.image = UIImage(named: "rad180")
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
            
            self.redLabel.hidden = false
            self.blueLabel.hidden = false
            
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
         self.scaleImageView.image = UIImage(named: "per180")
          
        }
        
        else if (protractorType == "Rad"){
           self.scaleImageView.image = UIImage(named: "rad180")
        }
        
        else {
            self.scaleImageView.image = UIImage(named: "180Iscale")
            
        }
     self.updateProtractorLabels(Float(angleReadOut))
    }
    
    
    
    
    
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        print("180 will appear")
//        self.angleReadOut = 270
//         self.view.layoutSubviews()
//    }
    
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
    @IBOutlet weak var blueTypeLabel: UILabel!
    @IBOutlet weak var redTypeLabel: UILabel!
    
    var angleReadOut: CGFloat = 0.0{
        didSet {
            if angleReadOut < 90.0 && angleReadOut >= 0 {
                angleReadOut = 360
            }
            
            if angleReadOut >= 90 && angleReadOut < 180 {
                angleReadOut = 180.0
            }
//            print("|angle is \(angleReadOut)")
//            angleView.setTheAngle(Float(angleReadOut))
//            let angle2 = 360.0 - angleReadOut
//            
//            
////            redTypeLabel.text = typeOfAngleFor(Float(angle2))
////            blueTypeLabel.text = typeOfAngleFor(Float(angleReadOut ) - 180.0)
////            blueLabel.text = String(format:"%.0f%", Float(angleReadOut) - 180.0) + "˚"
////            redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
//            
//           //new stuff
//        // let protractorType = (self.userDefaults.valueForKey("ProtractorType") as! String)
//         let π = Float(M_PI)
//        //  let p = 180/
//            if (protractor == "Per"){
//                
//                blueLabel.text = String(format:"%.1f%", (Float(angleReadOut) - 180.0)/360*100          ) + "%"
//                redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
//                
//            }
//                
//            else if (protractor == "Rad"){
//                blueLabel.text = String(format:"%.2f%", (Float(angle2) * π/180.0)) + "˚"
//                redLabel.text = String(format:"%.2f%", (Float(angle2) * π/180.0)) + " rad"
//                
//                
//                
//            }
//                
//            else {
//                redTypeLabel.text = typeOfAngleFor(Float(angle2))
//                blueTypeLabel.text = typeOfAngleFor(Float(angleReadOut ) - 180.0)
//                blueLabel.text = String(format:"%.0f%", Float(angleReadOut) - 180.0) + "˚"
//                redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
//                
//            }
            self.updateProtractorLabels(Float(angleReadOut))
         //new stuff end
        }
    }
    
    
    func updateProtractorLabels(angle: Float){
        print("|angle is \(angle)")
        angleView.setTheAngle(angle)
        let angle2 = 360.0 - angle
        
        
                    redTypeLabel.text = typeOfAngleFor(Float(angle2))
                   blueTypeLabel.text = typeOfAngleFor(Float(angleReadOut ) - 180.0)
        //            blueLabel.text = String(format:"%.0f%", Float(angleReadOut) - 180.0) + "˚"
        //            redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
        
        //new stuff
        // let protractorType = (self.userDefaults.valueForKey("ProtractorType") as! String)
        let π = Float(M_PI)
        //  let p = 180/
        if (protractor == "Per"){
            
            blueLabel.text = String(format:"%.1f%", (Float(angle) - 180.0)/360*100) + "%"
            redLabel.text = String(format:"%.1f%", (Float(angle2))/360*100) + "%"
            
        }
            
        else if (protractor == "Rad"){
            blueLabel.text = ""
            redLabel.text = String(format:"%.2f%", (Float(angle2) * π/180.0)) + " rad"
            
            
            
        }
            
        else {
           // redTypeLabel.text = typeOfAngleFor(Float(angle2))
           // blueTypeLabel.text = typeOfAngleFor(Float(angle ) - 180.0)
            blueLabel.text = String(format:"%.0f%", Float(angle) - 180.0) + "˚"
            redLabel.text = String(format:"%.0f%", Float(angle2)) + "˚"
            
        }
        
        //new stuff end
    
    
    
    }














    func rotateGesture(recognizer:OneFingerRotationGesture) {
        
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
