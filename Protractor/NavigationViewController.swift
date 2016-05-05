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
 , SettingsViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    let nc = NSNotificationCenter.defaultCenter()
   
    
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
         self.storeButton.enabled = false
        self.loadInAppPurchases()
        
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
    //segue	UIStoryboardSegue	0x7ca652b0	0x7ca652b0
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "Settings") {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = (nav.viewControllers[0] as! SettingsViewController)
            vc.delegate = self
        }
        
        if (segue.identifier == "Shop") {
           
            let nav = segue.destinationViewController as! UINavigationController
            let vc = (nav.viewControllers[0] as! ShopViewController)
            vc.pTitle = self.productTitle
            vc.pDescription = self.productDescription
            vc.pPrice = self.productPrice
           // vc.delegate = self
        }
    }
    
    
    
    
    
    
    //Code for IAP
    
    func loadInAppPurchases(){
        //setupIAP
        
                if(SKPaymentQueue.canMakePayments()){
                    print("Iap enabled loading")
                    let productID:NSSet = NSSet(objects: "uk.co.pongosoft.Protractor.camera")
                    let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
                    request.delegate = self
                    request.start()
                }
                    else{
        
                     print("Please enable IAP")
                    
                }
        
        
    }
    
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error Fetching product information");
        print(error.localizedDescription)
    }
    
    
    
    
    @IBOutlet weak var storeButton: UIButton!
    
   
    
    
    @IBAction func PurchaseCameraMode(sender: UIButton) {
        
        for product in list{
            let prodID = product.productIdentifier
            if (prodID == "uk.co.pongosoft.Protractor.camera"){
                
                p = product
                buyProduct()
                break;
                
            }
        }
        
    }
    
    
    
    @IBAction func restorePurchases(sender: UIButton) {
        //   if self.transactionObseved == false{
        //    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        //       self.transactionObseved = true
        // }
        
        
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        
    }
    
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct(){
        print("Buy" + p.productIdentifier)
        let pay = SKPayment(product: p)
        // if self.transactionObseved == false{
        //     SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        //      self.transactionObseved = true
        //  }
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
         SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
    }
    
    
    deinit {
        
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    var productTitle: String!
    var productDescription: String!
    var productPrice: String!
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct{
            print ("product added")
            print(product.productIdentifier)
            
            print(product.localizedTitle)
            self.productTitle = product.localizedTitle
            print(product.localizedDescription)
            self.productDescription = product.localizedDescription
            print(product.price)
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = product.priceLocale
            self.productPrice = numberFormatter.stringFromNumber(product.price)
            
           // self.productPrice = product.price
            list.append(product as SKProduct)
        }
        self.storeButton.enabled = true
        
        
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction: AnyObject in transactions{
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState{
            case.Purchased:
                print("Buy ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID{
                case "uk.co.pongosoft.Protractor.camera":
                    print("add cameraMode")
                default:
                    print("Iap not setup")
                    
                }
                queue.finishTransaction(trans)
                break;
                
            case .Failed:
                print("Buy error")
                queue.finishTransaction(trans)
                break;
                
                
            case .Restored:
                print("Restored")
                queue.finishTransaction(trans)
                break;
                
                
            case .Deferred:
                print("Deferred")
                // queue.finishTransaction(trans)
                break;
                
                
            default:
                print("default")
                break;
                
                
            }
            
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
        print("transaction restored")
        //  var puchasedItenID = []
        for transaction in queue.transactions{
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            switch prodID{
            case "uk.co.pongosoft.Protractor.camera":
                print("add cameraMode")
            default:
                print("Iap not setup")
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
}
