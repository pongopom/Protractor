//
//  SettingsViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 05/01/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import  UIKit


protocol SettingsViewControllerDelegate{
    func updateView()
    func showHideGuideLine()
}



class SettingsViewController: UITableViewController {
    
    
    var delegate: SettingsViewControllerDelegate! = nil
    @IBOutlet weak var showScaleSwitch: UISwitch!
    @IBOutlet weak var showAngleSwitch: UISwitch!
    @IBOutlet weak var showAngleTypeSwitch: UISwitch!
    @IBOutlet weak var showHorizontalGuideSwitch: UISwitch!
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var hideScale: Bool?
    var hideAngle: Bool?
    var hideAngleType: Bool?
    var hideHorizonGuide: Bool?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        tableView.estimatedRowHeight = 56.0
        
        //
        print("Settings view loaded")
        print(userDefaults.valueForKeyPath("HideScale"))
   self.setupUI()

       
    }
   
    //
    override func tableView(tableView: UITableView,
                            heightForRowAtIndexPath indexPath: NSIndexPath)
        -> CGFloat {
            return UITableViewAutomaticDimension
    }
    //
    
    func setupUI(){
        self.hideScale = (self.userDefaults.valueForKey("HideScale") as! Bool)
        if  (self.hideScale != nil) {
            if (self.hideScale == true){
                self.showScaleSwitch.setOn(false, animated: false)
            }
            else {
                self.showScaleSwitch.setOn(true, animated: false)
            }
        }
        
        self.hideAngle = (self.userDefaults.valueForKey("HideAngle") as! Bool)
        if  (self.hideAngle != nil) {
            if (self.hideAngle == true){
                self.showAngleSwitch.setOn(false, animated: false)
            }
            else {
                self.showAngleSwitch.setOn(true, animated: false)
            }
        }
       
        self.hideAngleType = (self.userDefaults.valueForKey("HideAngleType") as! Bool)
        if  (self.hideAngleType != nil) {
            if (self.hideAngleType == true){
                self.showAngleTypeSwitch.setOn(false, animated: false)
            }
            else {
                self.showAngleTypeSwitch.setOn(true, animated: false)
            }
        }
        
        
        
        
        
        
        self.hideHorizonGuide = (self.userDefaults.valueForKey("HideHorizon") as! Bool)
        if  (self.hideHorizonGuide != nil) {
            if (self.hideHorizonGuide == true){
                self.showHorizontalGuideSwitch.setOn(false, animated: false)
            }
            else {
                self.showHorizontalGuideSwitch.setOn(true, animated: false)
            }
        }
    }
    
    @IBAction func showHideScale(sender: UISwitch) {
        
        if sender.on == true{
            print("Scale on")
            
            self.userDefaults.setBool(false, forKey: "HideScale")
            //TO DO update user defs
        }
        else{
            
            if(self.showAngleSwitch.on == false){
               self.showAngleSwitch.setOn(true, animated: true)
              self.userDefaults.setBool(false, forKey: "HideAngle")
                //TO DO update user defs
            }
            
          self.userDefaults.setBool(true, forKey: "HideScale")
          print("Scale off")
        }
        self.delegate.updateView()
    }
    
    @IBAction func showHideAngle(sender: UISwitch) {
        if sender.on == true{
            print("angle on")
            self.userDefaults.setBool(false, forKey: "HideAngle")
        }
        else{
            
            if(self.showScaleSwitch.on == false){
                self.showScaleSwitch.setOn(true, animated: true)
                self.userDefaults.setBool(false, forKey: "HideScale")
                //TO DO update user defs
            }
            self.userDefaults.setBool(true, forKey: "HideAngle")
            print("angle off")
        }
       self.delegate.updateView() 
    }
    
    
    
    @IBAction func showHideAngleType(sender: UISwitch) {
        if sender.on == true{
           
            self.userDefaults.setBool(false, forKey: "HideAngleType")
        }
        else{
          
            self.userDefaults.setBool(true, forKey: "HideAngleType")
            
        }
        self.delegate.updateView()
        
    }
    
    
    
    
    
    
    @IBAction func showHideHorizonGuide(sender: UISwitch) {
        if sender.on == true{
            print("horizon on")
            self.userDefaults.setBool(false, forKey: "HideHorizon")
        }
        else{
            print("horizon off")
             self.userDefaults.setBool(true, forKey: "HideHorizon")
        }
        self.delegate.showHideGuideLine()
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        if tableView.cellForRowAtIndexPath(indexPath)!.tag == 10{
            print("bingo")
           // https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=337064413&type=Purple+Software
            
            let url = "itms-apps://itunes.apple.com/app/id\(555590467)"
            UIApplication.sharedApplication().openURL(NSURL(string: url)!)
            
        }
    }
    
    
    
    
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
}
