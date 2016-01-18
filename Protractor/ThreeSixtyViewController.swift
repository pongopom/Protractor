//
//  ThreeSixtyViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 04/11/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit
import AVFoundation
class ThreeSixtyViewController: UIViewController {

    
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    
    
    //MARK: View Controller override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(OneFingerRotationGesture(midPoint: self.view.center, target: self, action: "rotateGesture:"))
        
//                captureSession.sessionPreset = AVCaptureSessionPresetLow
//                let devices = AVCaptureDevice.devices()
//                print(devices)
//                // Loop through all the capture devices on this phone
//                for device in devices {
//                    // Make sure this particular device supports video
//                    if (device.hasMediaType(AVMediaTypeVideo)) {
//                        // Finally check the position and confirm we've got the back camera
//                        if(device.position == AVCaptureDevicePosition.Back) {
//                            captureDevice = device as? AVCaptureDevice
//                        }
//                    }
//                }
//                if captureDevice != nil {
//                    beginSession()
//                }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Handle camera methods
    
//        @IBOutlet weak var cameraView: UIView!
//    
//    
//       let captureSession = AVCaptureSession()
//        var captureDevice : AVCaptureDevice?
//        func beginSession() {
//            let input   : AVCaptureDeviceInput?
//            do {
//                input = try AVCaptureDeviceInput(device: captureDevice)
//                captureSession.addInput(input)
//    
//    
//            } catch _ {
//                print("Unable to find camera")
//            }
//          //  captureSession.addInput(input)
//    
//          let  previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            self.cameraView.layer.addSublayer(previewLayer)
//            previewLayer?.frame = self.view.layer.frame
//            captureSession.startRunning()
//        }
    
    
    
    
    
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
    
    @IBOutlet weak var angleView: AngleView!
    
    
    var angleReadOut: CGFloat = 0.0{
        didSet {
            angleReadOut = angleReadOut - 180
            if angleReadOut <= 0.0 {
                angleReadOut = angleReadOut + 360
            }
            print("|angle is \(angleReadOut)")
            
          //  let angle2 = 360.0 - angleReadOut
            
          //  blueLabel.text = String(format:"%.0f%", Float(angleReadOut))
           // redLabel.text = String(format:"%.0f%", Float(angle2))
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
            angleView.setTheAngle(Float(angle.degrees))
            //  self.view.layoutSubviews()
        }
        
        //        if let distance = recognizer.distance {
        //          //  feedbackLabel.text = feedbackLabel.text! + "\n" + String(format:"Distance: %.0f%", Float(distance))
        //        }
    }
    
}
