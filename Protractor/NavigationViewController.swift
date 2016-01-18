//
//  NavigationViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 03/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit
import iAd
import CoreMotion

class NavigationViewController: UIViewController
, ADBannerViewDelegate, SettingsViewControllerDelegate {
    
   // let userDefaults = NSUserDefaults.standardUserDefaults()
    let nc = NSNotificationCenter.defaultCenter()
    
    
    func updateView() {
        print("delegate func fired")
        nc.postNotificationName("UpdateTheUI", object: nil)
        
    }
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var swapViewControllersButton: UIButton!
 
    var oneEightyViewController: OneEightyViewController?
    var threeSixtyViewController: ThreeSixtyViewController?
    var hasMakePurchase: Bool?

    var UIiAd: ADBannerView?
   
    func loadTheAdBanner(){
                UIiAd = ADBannerView()
                UIiAd!.translatesAutoresizingMaskIntoConstraints = false
                UIiAd!.delegate = self
                self.view.addSubview(UIiAd!)
                let viewsDictionary = ["bannerView":UIiAd!]
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bannerView]|", options: [], metrics: nil, views: viewsDictionary))
                view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bannerView]", options: [], metrics: nil, views: viewsDictionary))
                UIiAd?.hidden = true
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
    print("banner didLoad")
        banner.hidden = false
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        banner.hidden = true
         print("banner didFail")
    }
    
    
    @IBOutlet weak var vCContainer: UIView!
    var viewsDictionary: NSDictionary!
    var tpConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leadConstraint: NSLayoutConstraint?
    var trailConstraint: NSLayoutConstraint?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    
    }

  

    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oneEightyViewController = storyboard.instantiateViewControllerWithIdentifier("180VC")
        self.oneEightyViewController = oneEightyViewController as? OneEightyViewController
        let threeSixtyViewController = storyboard.instantiateViewControllerWithIdentifier("360VC")
        self.threeSixtyViewController = threeSixtyViewController as? ThreeSixtyViewController
        self.loadInitialViewControllerWithName("180VC")
        
        if manager.deviceMotionAvailable {
            let queue = NSOperationQueue()
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdatesToQueue(queue) {
                 (data: CMDeviceMotion?, error: NSError?) in
                let rotation = atan2(data!.gravity.y, data!.gravity.x) * -1
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                
                //- M_PI
                self.line.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                if rotation < 0.01 && rotation > -0.01{
              if rotation < 0.003 && rotation > -0.003{
                    self.line.backgroundColor = UIColor.greenColor()
                    }
              else{
                self.line.backgroundColor = UIColor.orangeColor()
                
                
                    }
                
                }
                else{
              //    print("turn blue")
                    self.line.backgroundColor = UIColor.redColor()
                }
                }
               // print(rotation)
            }
        }
        hasMakePurchase = false
        if hasMakePurchase == false{
   self.loadTheAdBanner()
        }
    }
    
    var loadedViewControllerName: String?
    
    func loadInitialViewControllerWithName(name: String){
       if name == "180VC" {
    
        self.loadedViewControllerName = name
        self.addChildViewController(self.oneEightyViewController!)
        self.oneEightyViewController?.view.frame = self.containerView.frame
        self.containerView.addSubview((self.oneEightyViewController?.view)!)
        self.oneEightyViewController?.didMoveToParentViewController(self)
        print(self.containerView.frame)
        //check the h line
      //  self.positionHorizonLineFor(self.loadedViewControllerName!)
        }
       else {
        
        }
    }
   
    
    @IBOutlet weak var lineToBottom: NSLayoutConstraint!
    
    func positionHorizonLineFor(vcName: String){
        if vcName == "180VC"{
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
                print("we are a 180 prot on an ipad or 6plus")
                self.lineToBottom.constant = 25
                UIView.animateWithDuration(0.2) {
                    self.view.layoutIfNeeded()
                }
                
                
            }
            else {
               print("we are a 180 prot on an ipone")
                self.lineToBottom.constant = 25
                UIView.animateWithDuration(0.2) {
                    self.view.layoutIfNeeded()
                }
                
            }
        }
        else {
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
                print("we are a 360 prot on an ipad or 6plus")
                
                self.lineToBottom.constant = self.view.frame.height/2
               UIView.animateWithDuration(0.2) {
                    self.view.layoutIfNeeded()
                }
                
            }
            else{
            print("we are a 360 prot on an ipone")
                
                self.lineToBottom.constant = self.view.frame.height/2
                UIView.animateWithDuration(0.2) {
                    self.view.layoutIfNeeded()
                }
                
            }
        }
    }
    
    
 
    
    
    
    
    @IBAction func swapViewControllers(sender: UIButton) {
        if self.loadedViewControllerName == "180VC" {
           //  UIiAd.hidden = true
            sender.enabled = false
            self.oneEightyViewController?.willMoveToParentViewController(nil)
            self.addChildViewController(self.threeSixtyViewController!)
            self.transitionFromViewController(self.oneEightyViewController!, toViewController: self.threeSixtyViewController!, duration: 0.2, options:UIViewAnimationOptions.TransitionCrossDissolve,
                animations: nil,completion: { finished in
                self.oneEightyViewController!.removeFromParentViewController()
                self.threeSixtyViewController!.didMoveToParentViewController(self)
                self.threeSixtyViewController!.view.frame = self.containerView.frame
                    self.loadedViewControllerName = "360VC"
                    // move the h line
                    self.positionHorizonLineFor(self.loadedViewControllerName!)
                    sender.enabled = true
            })
        }
        else {
            sender.enabled = false
            self.threeSixtyViewController?.willMoveToParentViewController(nil)
            self.addChildViewController(self.oneEightyViewController!)
            self.transitionFromViewController(self.threeSixtyViewController!, toViewController: self.oneEightyViewController!, duration: 0.2, options:UIViewAnimationOptions.TransitionCrossDissolve,
                animations: nil,completion: { finished in
                    self.threeSixtyViewController!.removeFromParentViewController()
                    self.oneEightyViewController!.didMoveToParentViewController(self)
                    self.oneEightyViewController!.view.frame = self.containerView.frame
                    self.loadedViewControllerName = "180VC"
                    //move the h line
                    self.positionHorizonLineFor(self.loadedViewControllerName!)
                    sender.enabled = true
            })
        }
    }

   //MARK: Camera methods
        @IBOutlet weak var camView: UIView!
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var  previewLayer: AVCaptureVideoPreviewLayer?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        //  self.view.layoutSublayersOfLayer(self.camView.layer)
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeLeft
    }
    
    
    func loadTheCamera(){
        //Cam stuff
        captureSession.sessionPreset = AVCaptureSessionPresetMedium
        let devices = AVCaptureDevice.devices()
        print(devices)
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    ////
                    do {
                        try captureDevice!.lockForConfiguration()
                        captureDevice?.focusMode = .ContinuousAutoFocus
                        print("cool")
                        captureDevice!.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                    ////
                }
            }
        }
        if captureDevice != nil {
              beginSession()
        }
            
        else {
            
            print("Unable to activate camera")
            
        }
        
        
    }
    
    
    func beginSession() {
        let input   : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            
        } catch _ {
            print("Unable to find camera")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = self.view.bounds
        print(self.view.bounds)
        previewLayer!.connection.videoOrientation = AVCaptureVideoOrientation.LandscapeLeft
        self.camView.layer.addSublayer(previewLayer!)
        captureSession.startRunning()
    }
    
    
    func endSession(){
        captureSession.stopRunning()
        if let oldInputs = self.previewLayer?.session.inputs{
            for oldInput in oldInputs{
                self.previewLayer?.session.removeInput(oldInput as! AVCaptureInput)
                
                self.previewLayer!.removeFromSuperlayer()
                self.previewLayer = nil
                if(self.previewLayer?.session == nil){
                    print("previewSession = nil")
                }
                if(self.previewLayer == nil){
                    print("preview = nil")
                    
                }
                
            }
        }
        
        
    }
    
    
    
    
    
    @IBAction func start(sender: AnyObject) {
        
        
        if captureSession.running == true{
            print("capture is running")
            return
        }
        
        self.loadTheCamera()
      //  beginSession()
       // captureSession.startRunning()
    }
    
    @IBAction func stop(sender: UIButton) {
        if captureSession.running == true{
         self.endSession()
        }
        else {
            
           print("fire up camera")
            
         self.loadTheCamera()
        }
    }
    
    
  //MARK: horizon line
    let manager: CMMotionManager = CMMotionManager()
    @IBOutlet weak var line: UIView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Settings") {
            let nav = segue.destinationViewController as! UINavigationController
           let vc = (nav.viewControllers[0] as! SettingsViewController)
            vc.delegate = self
        }
    }
 
    
    
}
