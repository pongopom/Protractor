//
//  NavigationViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 03/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//
import StoreKit
import UIKit
import AVFoundation
import CoreMotion

class NavigationViewController: UIViewController
, SettingsViewControllerDelegate, UpgradeTableviewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let nc = NSNotificationCenter.defaultCenter()
    let helper = StoreManager.sharedInstance
    var showStoreView = "failed"
    
    //settings delegate method
    func updateView() {
        print("delegate func fired")
        nc.postNotificationName("UpdateTheUI", object: nil)
        
    }
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func changeScaleType(sender: UIButton) {
        
        //   var protractorType = (self.userDefaults.valueForKey("ProtractorType") as! String)
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        let degrees: UIAlertAction = UIAlertAction(title: "Degrees", style: .Default)
        { action -> Void in
            
            self.userDefaults.setObject("Deg", forKey: "ProtractorType")
            self.nc.postNotificationName("UpdateProtractorType", object: nil)
            sender.setImage(UIImage(named: "degButton"), forState: UIControlState.Normal)
        }
        
        
        let percentage: UIAlertAction = UIAlertAction(title: "Percentage", style: .Default)
        { action -> Void in
            
            self.userDefaults.setObject("Per", forKey: "ProtractorType")
            self.nc.postNotificationName("UpdateProtractorType", object: nil)
            sender.setImage(UIImage(named: "perButton"), forState: UIControlState.Normal)
        }
        
        
        let radians: UIAlertAction = UIAlertAction(title: "Radians", style: .Default)
        { action -> Void in
            
            self.userDefaults.setObject("Rad", forKey: "ProtractorType")
            self.nc.postNotificationName("UpdateProtractorType", object: nil)
            sender.setImage(UIImage(named: "radButton"), forState: UIControlState.Normal)
        }
        
        let scaleType = self.userDefaults.valueForKey("ProtractorType") as! String
        if scaleType == "Per"{
            actionSheetController.addAction(degrees)
            actionSheetController.addAction(radians)
        }
            
        else if scaleType == "Rad"{
            actionSheetController.addAction(degrees)
            actionSheetController.addAction(percentage)
            
            
        }
        else{
            actionSheetController.addAction(percentage)
            actionSheetController.addAction(radians)
        }
        
        
        
        actionSheetController.popoverPresentationController?.sourceView = sender as UIView
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        actionSheetController.view.layoutIfNeeded()//supress warning
        
    }
    
    
    @IBOutlet weak var scaleTypeButton: UIButton!
    
    func updateScaleTypeButtonImage (){
        let scaleType = self.userDefaults.valueForKey("ProtractorType") as! String
        
        if scaleType == "Per"{
            self.scaleTypeButton.setImage(UIImage(named: "perButton"), forState: UIControlState.Normal)
        }
            
        else if scaleType == "Rad"{
            self.scaleTypeButton.setImage(UIImage(named: "radButton"), forState: UIControlState.Normal)
            
        }
        else{
            
            self.scaleTypeButton.setImage(UIImage(named: "degButton"), forState: UIControlState.Normal)
        }
        
    }
    
    
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var swapViewControllersButton: UIButton!
    var oneEightyViewController: OneEightyViewController?
    var threeSixtyViewController: ThreeSixtyViewController?
    var hasMakePurchase: Bool?
    
    
    @IBOutlet weak var vCContainer: UIView!
    var viewsDictionary: NSDictionary!
    var tpConstraint: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    var leadConstraint: NSLayoutConstraint?
    var trailConstraint: NSLayoutConstraint?
    
    //    override func viewWillLayoutSubviews() {
    //          positionHorizonLineFor(self.loadedViewControllerName!)
    //        super.viewWillLayoutSubviews()
    //
    //    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        positionHorizonLineFor(self.loadedViewControllerName!)
        ////////for screenshots remove befor shipping
        
        self.line.transform = CGAffineTransformMakeRotation(CGFloat(0.05))
        self.line.backgroundColor = UIColor.redColor()
        
        ///////////
        print(self.userDefaults.valueForKey("ProtractorType") as! String)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let oneEightyViewController = storyboard.instantiateViewControllerWithIdentifier("180VC")
        self.oneEightyViewController = oneEightyViewController as? OneEightyViewController
        let threeSixtyViewController = storyboard.instantiateViewControllerWithIdentifier("360VC")
        self.threeSixtyViewController = threeSixtyViewController as? ThreeSixtyViewController
        self.loadInitialViewControllerWithName("180VC")
        
        hasMakePurchase = false
        if hasMakePurchase == false{
            //   self.loadTheAdBanner()
        }
        
        
        let showGuide = self.userDefaults.valueForKey("HideHorizon") as! Bool
        
        if showGuide == true{
            self.line.hidden = true
        }
        else {
            self.line.hidden = false
            self.startHorizontalGuide()
        }
        
        
        
        
        
        self.updateScaleTypeButtonImage()
        
        
        //////////////
        
        self.storeButton.enabled = false
      //  self.loadInAppPurchases()
        self.show360Button()
        self.showScalesButton()
        
        
        //  helper.loadInAppPurchases()
        ///////////////
        
    }
    
    
    
    
    
    
    
    func showHideGuideLine(){
        let showGuide = self.userDefaults.valueForKey("HideHorizon") as! Bool
        
        if showGuide == true{
            
            
            if manager.deviceMotionActive {
                
                manager.stopDeviceMotionUpdates()
            }
            self.line.hidden = true
        }
        else {
            
            self.line.hidden = false
            self.startHorizontalGuide()
            
            
            
        }
        //  self.line.hidden = true
    }
    
    
    func startHorizontalGuide(){
        //    let showGuide = self.userDefaults.valueForKey("HideHorizon") as! Bool
        
        
        
        if manager.deviceMotionAvailable {
            let queue = NSOperationQueue()
            manager.deviceMotionUpdateInterval = 0.01
            manager.startDeviceMotionUpdatesToQueue(queue) {
                (data: CMDeviceMotion?, error: NSError?) in
                let rotation = atan2(data!.gravity.y, data!.gravity.x) * -1
                
                //   let phoneAngle = atan2(data!.gravity.z, data!.gravity.x) * -1
                //  print(phoneAngle)
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    print("roll")
                    print(data?.attitude.roll)
                    
                    
                    print("pitch")
                    print(data?.attitude.pitch)
                    
                    
                    
                    
                    if data?.attitude.roll < -0.5 || data?.attitude.roll > 0.5{
                        
                        
                        
                        print("Bingo")
                        //  if showGuide == false {
                        //  self.line.hidden = false
                        
                        self.line.alpha = 1
                        
                        // print(rotation)
                        // }
                    }
                    else{
                        if data!.attitude.pitch < 1 && data!.attitude.pitch > -1 {
                            self.line.alpha = 0
                            /// self.line.hidden = true
                        }
                    }
                    
                    
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
                        self.line.backgroundColor = UIColor.redColor()
                    }
                }
            }
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
        }
    }
    
    @IBOutlet weak var lineToBottom: NSLayoutConstraint!
    
    func positionHorizonLineFor(vcName: String){
        if vcName == "180VC"{
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
                print("we are a 180 prot on an ipad or 6plus")
                //                self.lineToBottom.constant = 25
                //                UIView.animateWithDuration(0.2) {
                //                    self.view.layoutIfNeeded()
                //                }
                
                self.lineToBottom.constant = 30
                self.view.layoutIfNeeded()
                
            }
            else {
                print("we are a 180 prot on an ipone")
                //                self.lineToBottom.constant = 25
                //                UIView.animateWithDuration(0.2) {
                //                    self.view.layoutIfNeeded()
                //                }
                
                
                self.lineToBottom.constant = 25
                self.view.layoutIfNeeded()
                
                
            }
        }
        else {
            if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.Regular) {
                print("we are a 360 prot on an ipad or 6plus")
                
                //                self.lineToBottom.constant = self.view.frame.height/2
                //               UIView.animateWithDuration(0.2) {
                //                    self.view.layoutIfNeeded()
                //                }
                
                
                self.lineToBottom.constant = self.view.frame.height/2
                self.view.layoutIfNeeded()
                
                
            }
            else{
                print("we are a 360 prot on an ipone")
                
                //                self.lineToBottom.constant = self.view.frame.height/2
                //                UIView.animateWithDuration(0.2) {
                //                    self.view.layoutIfNeeded()
                //                }
                
                
                self.lineToBottom.constant = self.view.frame.height/2
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    @IBAction func swapViewControllers(sender: UIButton) {
        let Image360: UIImage = UIImage(named: "3602xiphone")!
        let Image180: UIImage = UIImage(named: "1802xiphone")!
        if self.loadedViewControllerName == "180VC" {
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
                                                sender.setImage(Image360, forState: UIControlState.Normal)
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
                                                sender.setImage(Image180, forState: UIControlState.Normal)
            })
        }
    }
    
    //MARK: Camera methods
    @IBOutlet weak var camView: UIView!
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var  previewLayer: AVCaptureVideoPreviewLayer?
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    
    @IBOutlet weak var cameraButton: UIButton!
    
    func beginSession() {
        let input   : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            cameraButton.tintColor = UIColor.redColor()
            
        } catch _ {
            print("Unable to find camera")
            
            if captureSession.running == true{
                self.endSession()
                
            }
            self.cameraButton.tintColor = self.view.tintColor
            //:TO DO ADD NOTIFICATION
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
        cameraButton.tintColor = self.view.tintColor
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
    
    
    @IBAction func stop(sender: UIButton) {
        
        
        if captureSession.running == true{
            self.endSession()
        }
        else {
            print("fire up camera")
            checkPermition()
        }
    }
    
    func checkPermition(){
        if AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.Authorized {
            self.loadTheCamera()
        }
        else if
            AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.NotDetermined {
            
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (videoGranted: Bool) -> Void in
                
                // User clicked ok
                if (videoGranted) {
                    
                    self.loadTheCamera()
                    print("User tapped  allow")
                    // User clicked don't allow
                } else {
                    
                    print("User tapped dont allow")
                    
                    // self.endSession()
                    //  self.cameraButton.tintColor = self.view.tintColor
                    
                    // imagePickerController.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
        else if
            AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == AVAuthorizationStatus.Denied {
            
            let alertController = UIAlertController(title: "Unable to activate camera", message: "Check that Free Protractor has permission to use the camera in the device settings", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            print("User deni")
        }
    }
    
    
    //MARK: horizon line
    let manager: CMMotionManager = CMMotionManager()
    @IBOutlet weak var line: UIView!
    
    
    
    var upgradeVC:UpgradeTableviewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Settings") {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = (nav.viewControllers[0] as! SettingsViewController)
            vc.delegate = self
        }
        
        if (segue.identifier == "store") {
            
            let nav = segue.destinationViewController as! UINavigationController
            let vc = (nav.viewControllers[0] as! UpgradeTableviewController)
            self.upgradeVC = vc
            //            vc.pTitle = self.productTitle
            //            vc.pDescription = self.productDescription
            //            vc.pPrice = self.productPrice
            vc.delegate = self
            
            
            let showScales = self.userDefaults.valueForKey("ScaleP") as! Bool
            
            if showScales == true{
                print("HideThe Button")
                
                self.upgradeVC.showTypeButton = false
            }
            else {
                // show button
               self.upgradeVC.showTypeButton = true
            }
            
            
            self.upgradeVC.three60Title = self.three60Title
            self.upgradeVC.three60Description = self.three60Description
             let purchaseState = self.userDefaults.valueForKey("Three60State")as! String
            if purchaseState == "purchasing"{
             self.upgradeVC.three60Price = "Purchasing"
            }
            
            else if purchaseState == "purchased" {
                
              self.upgradeVC.three60Price = "Purchased"
            }
            
            else if purchaseState == "notPurchased" {
                
              self.upgradeVC.three60Price = self.three60Price
            }
            
            else if purchaseState == "deferred" {
                
              self.upgradeVC.three60Price = "Waiting permission"
            }
           // self.upgradeVC.three60Price = self.three60Price
            
            self.upgradeVC.scaleTitle = self.scaleTitle
            self.upgradeVC.scaleDescription = self.scaleDescription
            self.upgradeVC.scalePrice = self.scalePrice
            
            
            
            
        }
    }
    
    
    
    
    
    
    //Code for IAP
    
    func showScalesButton(){
        
        let showScales = self.userDefaults.valueForKey("ScaleP") as! Bool
        print(showScales)
        if showScales == true{
            print("HideThe Button")
            
            self.scaleTypeButton.hidden = false
        }
        else {
            // show button
            self.scaleTypeButton.hidden = true
        }
    }
    
    
    func show360Button(){
        let show360 = self.userDefaults.valueForKey("three60P") as! Bool
        
        if show360 == true{
            //hide button
            self.swapViewControllersButton.hidden = false
        }
        else {
            // show button
            self.swapViewControllersButton.hidden = true
        }
        
    }
    
    
    //upgradeViewDelegateMethods
    
    func buyScale(){
        
        
        
        print("buyScale")
        for product in list{
            let prodID = product.productIdentifier
            if (prodID ==  "uk.co.pongosoft.Protractor.camera"){
                
                p = product
                buyProduct()
                break;
                
            }
        }
        
        
        
        
        //        if (upgradeVC != nil) {
        //
        //          upgradeVC.priceType.text = "Installed"
        //          upgradeVC.buyButtonType.enabled = false
        //        }
    }
    
    
    func buy360(){
        
        
        for product in list{
            let prodID = product.productIdentifier
            if (prodID == "uk.co.pongosoft.Protractor.360"){
                
                p = product
                buyProduct()
                break;
                
            }
        }
        
        
        print("buy360")
    }
    
    
    func  restoreProducts(){
        print("restore")
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    
    
    func loadInAppPurchases(){
        //setupIAP
        
        if(SKPaymentQueue.canMakePayments()){
            print("Iap enabled loading")
            let productID:NSSet = NSSet(objects: "uk.co.pongosoft.Protractor.camera", "uk.co.pongosoft.Protractor.360")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        }
        else{
            
            print("Please enable IAP")
            self.showStoreView = "notAllowed"
            self.storeButton.enabled = true
        }
        
        
    }
    
    
    var requestError = ""
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error Fetching product information");
        print(error.localizedDescription)
        
        self.showStoreView = "failed"
        self.requestError = error.localizedDescription
        self.storeButton.enabled = true
    }
    
    
    
    
    @IBOutlet weak var storeButton: UIButton!
    
    
    @IBAction func showUpgradeOptions(sender: AnyObject) {
        
        print(showStoreView)
        
        switch self.showStoreView {
        case "notAllowed":
            let alertController = UIAlertController(title: "Purchase", message: "In app purchases are not allowed on this device", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            break
            
        case "failed":
            let alertController = UIAlertController(title: "Error", message:  self.requestError, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            
            
            break
            
        case "passed":
            
            print("good to go")
            self.performSegueWithIdentifier("store", sender: nil)
            break
            
        default:
            break
            
        }
        
        
    }
    
    
    //    @IBAction func PurchaseCameraMode(sender: UIButton) {
    //
    //        for product in list{
    //            let prodID = product.productIdentifier
    //            if (prodID == "uk.co.pongosoft.Protractor.camera"){
    //
    //                p = product
    //                buyProduct()
    //                break;
    //
    //            }
    //        }
    //
    //    }
    //
    //
    //
    //    @IBAction func restorePurchases(sender: UIButton) {
    //        //   if self.transactionObseved == false{
    //        //    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    //        //       self.transactionObseved = true
    //        // }
    //
    //
    //        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    //
    //    }
    
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct(){
        print("Buy" + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(NavigationViewController.applicationActive(_:)),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    
    deinit {
        
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
   
    
    
    
    func applicationActive(notification: NSNotification) {
        print("VCActive")
     //   if self.showStoreView != "passed"{
            self.storeButton.enabled = false
            self.loadInAppPurchases()
      //  }
        
        // do something
    }
    
    
    
    
    var productTitle: String!
    var productDescription: String!
    var productPrice: String!
    
    var scaleTitle: String!
    var scaleDescription: String!
    var scalePrice: String!
    var three60Title: String!
    var three60Description: String!
    var three60Price: String!
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        list = myProduct
        print(myProduct.count)
        for product in myProduct{
            
            
            //            print ("product added")
            //            print(product.productIdentifier)
            //            print(product.localizedTitle)
            //            self.productTitle = product.localizedTitle
            //            print(product.localizedDescription)
            //            self.productDescription = product.localizedDescription
            //            print(product.price)
            //            let numberFormatter = NSNumberFormatter()
            //            numberFormatter.numberStyle = .CurrencyStyle
            //            numberFormatter.locale = product.priceLocale
            //            self.productPrice = numberFormatter.stringFromNumber(product.price)
            //            list.append(product as SKProduct)
            
            if product.productIdentifier == "uk.co.pongosoft.Protractor.camera"{
                print ("product added")
                print(product.productIdentifier)
                print(product.localizedTitle)
                self.scaleTitle = product.localizedTitle
                print(product.localizedDescription)
                self.scaleDescription = product.localizedDescription
                print(product.price)
               
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                numberFormatter.locale = product.priceLocale
                self.scalePrice = numberFormatter.stringFromNumber(product.price)
                //  list.append(product as SKProduct)
            }
            
            if product.productIdentifier == "uk.co.pongosoft.Protractor.360"{
                print ("product added")
                print(product.productIdentifier)
                print(product.localizedTitle)
                self.three60Title = product.localizedTitle
                print(product.localizedDescription)
                self.three60Description = product.localizedDescription
                print(product.price)
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                numberFormatter.locale = product.priceLocale
                self.three60Price = numberFormatter.stringFromNumber(product.price)
                // list.append(product as SKProduct)
            }
            
            
            
        }
        
        self.showStoreView = "passed"
        self.storeButton.enabled = true
        
        print(list.count)
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction: AnyObject in transactions{
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState{
            case.Purchasing:
                print("purchasing")

                let ID = transaction.payment.productIdentifier
                switch ID{
                case "uk.co.pongosoft.Protractor.camera":
                    print("purchasing cam")
                    self.userDefaults.setObject("purchasing", forKey: "ScaleState")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.priceType.text = "Purchasing"}
                    break
            
                case "uk.co.pongosoft.Protractor.360":
                    print("purchasing 360")
                    self.userDefaults.setObject("purchasing", forKey: "Three60State")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.price360.text = "Purchasing"}
                    break
                    
                default: break
 
                }
                
                break
                
                
            case.Purchased:

                let ID = transaction.payment.productIdentifier
                unlockProductForID(ID)
                switch ID{
                case "uk.co.pongosoft.Protractor.camera":
                    print("purchasing cam")
                    self.userDefaults.setObject("purchased", forKey: "ScaleState")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.priceType.text = "Purchased"}
                    break
                    
                case "uk.co.pongosoft.Protractor.360":
                    print("purchasing 360")
                    self.userDefaults.setObject("purchased", forKey: "Three60State")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.price360.text = "Purchased"}
                    break
                    
                default: break
                    
                }
                queue.finishTransaction(trans)
                break
                
            case .Failed:
                print("Buy error")
                let ID = transaction.payment.productIdentifier
                switch ID{
                case "uk.co.pongosoft.Protractor.camera":
                    print("purchasing cam")
                    self.userDefaults.setObject("notPurchased", forKey: "ScaleState")
                    if (self.upgradeVC != nil) && (self.scalePrice != nil){
                        self.upgradeVC.priceType.text = self.scalePrice}
                    break
                    
                case "uk.co.pongosoft.Protractor.360":
                    print("purchasing 360")
                    self.userDefaults.setObject("notPurchased", forKey: "Three60State")
                    if (self.upgradeVC != nil) && (self.three60Price != nil) {
                        self.upgradeVC.price360.text = self.three60Price}
                    break
                    
                default: break
                    
                }
                
                //  print(transaction.localizedFailureReason)
                if transaction.error?!.code == SKErrorCode.PaymentCancelled.rawValue {
                    print("User Cancelled Payment")
                }
                else {
                    if let error = transaction.error {
                        /// Preferably show an alert here
                        print(error?.localizedDescription)
                    }
                }
                
                
                queue.finishTransaction(trans)
                break;
                
                
            case .Restored:
                print("Restored")
                /// safely unwrap originalTransaction as its an optional
                if let originalTransaction = transaction.originalTransaction {
                    let ID = originalTransaction!.payment.productIdentifier
                    unlockProductForID(ID)
                    
                    switch ID{
                    case "uk.co.pongosoft.Protractor.camera":
                        print("purchasing cam")
                        self.userDefaults.setObject("purchased", forKey: "ScaleState")
                        if (self.upgradeVC != nil) {
                            self.upgradeVC.priceType.text = "Purchased"}
                        break
                        
                    case "uk.co.pongosoft.Protractor.360":
                        print("purchasing 360")
                        self.userDefaults.setObject("purchased", forKey: "Three60State")
                        if (self.upgradeVC != nil) {
                            self.upgradeVC.price360.text = "Purchased"}
                        break
                        
                    default: break
                    }
                }
                
                queue.finishTransaction(trans)
                break
                
                
            case .Deferred:
                print("Deferred")
               
                let ID = transaction.payment.productIdentifier
                switch ID{
                case "uk.co.pongosoft.Protractor.camera":
                    print("purchasing cam")
                    self.userDefaults.setObject("deferred", forKey: "ScaleState")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.priceType.text = "Waiting permission"}
                    break
                    
                case "uk.co.pongosoft.Protractor.360":
                    print("purchasing 360")
                    self.userDefaults.setObject("deferred", forKey: "Three60State")
                    if (self.upgradeVC != nil) {
                        self.upgradeVC.price360.text = "Waiting permission"}
                    break
                    
                default: break
                    
                }
                
                
                break
                
                
                //            default:
                //                print("default")
                //                break;
                
                
            }
            
        }
        
    }
    
    
    func unlockProductForID(productID: String) {
        switch productID {
            
        case "uk.co.pongosoft.Protractor.360":
            print("unlock the 360")
            self.userDefaults.setBool(true, forKey: "three60P")
            self.swapViewControllersButton.hidden = false
            
            
            
            break;
        case "uk.co.pongosoft.Protractor.camera":
            print("unlock the camera")
            self.userDefaults.setBool(true, forKey:  "ScaleP")
            self.scaleTypeButton.hidden = false
            break;
            
        default:
            print("default")
            break;
            
            /// unlock product for correct ID
        }
    }
    
    
    
    func finishTransaction(trans:SKPaymentTransaction){
        print("Finished trans")
        SKPaymentQueue.defaultQueue().finishTransaction(trans)
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans")
        
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        guard queue.transactions.count != 0 else {
            // showAlert that nothing restored
            
            print("Nothing to restore")
            return
        }
        print("restore successful")
        // show restore successful alert
    }
    
    // Restore failed
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        print(error.localizedDescription)
        /// handle the restore error if you need to.
    }
    
    
    
    
    
    //    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
    //        print("transaction restored")
    //        //  var puchasedItenID = []
    //        for transaction in queue.transactions{
    //            let t: SKPaymentTransaction = transaction
    //            let prodID = t.payment.productIdentifier as String
    //            switch prodID{
    //            case "uk.co.pongosoft.Protractor.camera":
    //                print("add cameraMode")
    //            default:
    //                print("Iap not setup")
    //                
    //            }
    //            
    //        }
    //        
    //        
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
