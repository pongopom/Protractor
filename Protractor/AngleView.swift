//
//  AngleView.swift
//  cgtest
//
//  Created by Peter Pomlett on 01/10/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit


//extension Float {
//    var degreesToRadians : Float {
//        return Float(self) * Float(M_PI) / 180.0
//    }
//}


class AngleView: UIView {

    
    var touchedAngle: Float?
    
    func setTheAngle (angl:Float){
    touchedAngle = angl
        self.layoutSubviews()
       
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.size.width/2
      //  self.layer.masksToBounds = true
                
    }

    
    var circleLayerRed: CAShapeLayer?
    var circleLayerBlue: CAShapeLayer?
     var pointerLayer: CAShapeLayer?
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        if  (circleLayerRed != nil){
            circleLayerRed?.removeFromSuperlayer()
            circleLayerRed = nil
        }

        
       circleLayerRed = CAShapeLayer(layer: layer)
        // circleLayerRed.opacity = 0.5
        circleLayerRed!.lineWidth = 1
      //  circleLayerRed!.strokeColor = UIColor(red: 1.0, green: 0.2, blue: 0.1, alpha: 1.0).CGColor
        circleLayerRed!.fillColor = UIColor(red: 1.0, green: 0.2, blue: 0.1, alpha: 0.3).CGColor
        
        circleLayerRed!.shadowColor = UIColor.redColor().CGColor
        circleLayerRed!.shadowRadius = 6.0
        circleLayerRed!.shadowOpacity = 0.4
        circleLayerRed!.shadowOffset = CGSize(width: 0, height: 0)
        
        
        self.layer.addSublayer(circleLayerRed!)
        let center = CGPointMake(bounds.width/2 , bounds.height/2)
        let radius: CGFloat = bounds.width/2
        let piePath = UIBezierPath()
        piePath.moveToPoint(center)
        
        if  (touchedAngle == nil)
        {
            touchedAngle = 180
        }
        
      //  let angle: Float = -100.0
        
       let angle = touchedAngle! //* -1.0
        
        let angleb: Float =  360      //was 180
       // let angle: Float = 180
      //  let angleb = touchedAngle!
        
        let b = cosf(angle.degreesToRadians)
        let c = sinf(angle.degreesToRadians)
        piePath.addLineToPoint(CGPointMake(center.x + (radius )  * CGFloat(b), center.y + (radius) * CGFloat(c)))
        piePath.addArcWithCenter(center, radius: radius, startAngle: CGFloat(angle.degreesToRadians), endAngle:CGFloat(angleb.degreesToRadians) , clockwise: true)
        
        // piePath.addArcWithCenter(center, radius: radius, startAngle: CGFloat(angleb.degreesToRadians), endAngle:CGFloat(angle.degreesToRadians) , clockwise: true)
        
        
        piePath.addLineToPoint(center)
        circleLayerRed!.path = piePath.CGPath
        
        
        
        
        if  (circleLayerBlue != nil){
            circleLayerBlue?.removeFromSuperlayer()
            circleLayerBlue = nil
        }
        
        
        
        
        
        
         circleLayerBlue = CAShapeLayer(layer: layer)
       // circleLayerBlue.opacity = 0.5
        circleLayerBlue!.lineWidth = 1
        circleLayerBlue!.fillColor = UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 0.3).CGColor
      //  circleLayerBlue!.strokeColor =  UIColor(red: 0.1, green: 0.1, blue: 1.0, alpha: 1.0).CGColor
        
        circleLayerBlue!.shadowColor = UIColor.blueColor().CGColor
        circleLayerBlue!.shadowRadius = 6.0
        circleLayerBlue!.shadowOpacity = 0.4
        circleLayerBlue!.shadowOffset = CGSize(width: 0, height: 0)
        
        self.layer.addSublayer(circleLayerBlue!)
      //  let center = CGPointMake(bounds.width/2, bounds.height)
      //  let radius: CGFloat = bounds.width/2
        let piePath2 = UIBezierPath()
        
        
        
        piePath2.moveToPoint(center)
        var angle2: Float = 360    //was 180
        let angleb2: Float = touchedAngle! //* -1.0
       //////////
        //was 180
//        if angleb2 == 360{
//            
//            angle2 = -360
//            
//        }
//        else {
//            angle2 = 360
//        }
        
        
        if angleb2 == 0{
            
            angle2 = 0
            
        }
        else {
            angle2 = 360
        }
        
        
        
        
        
     /////////////
        let b1 = cosf(angle2.degreesToRadians)
        let c1 = sinf(angle2.degreesToRadians)
         let center2 = CGPointMake(bounds.width/2  , bounds.height/2)
       
        
        piePath2.addLineToPoint(CGPointMake(center2.x  + (radius )  * CGFloat(b1), center2.y + (radius) * CGFloat(c1)))
       // circleLayerBlue.lineWidth = 1
      //  circleLayerBlue.lineWidth = 8
        piePath2.addArcWithCenter(center2 , radius: radius, startAngle: CGFloat(angle2.degreesToRadians), endAngle:CGFloat(angleb2.degreesToRadians) , clockwise: true)
       
        piePath2.addLineToPoint(center2)
        circleLayerBlue!.path = piePath2.CGPath
       
     ////////////////////
        
        
        
        if  (pointerLayer != nil){
            pointerLayer?.removeFromSuperlayer()
            pointerLayer = nil
        }
        
        
        
        let d1 = cosf(angleb2.degreesToRadians)
        let e1 = sinf(angleb2.degreesToRadians)
        
        
        pointerLayer = CAShapeLayer(layer: layer)
        
        pointerLayer!.lineWidth = 1
       
        pointerLayer!.strokeColor =  UIColor.blackColor().CGColor
        pointerLayer?.lineDashPattern = [4,4]
        self.layer.addSublayer(pointerLayer!)
       
        let pointerPath = UIBezierPath()

        pointerPath.moveToPoint(center2)
        pointerPath.addLineToPoint(CGPointMake(center2.x  + ( self.superview!.bounds.size.width )  * CGFloat(d1), center2.y + ( self.superview!.bounds.size.width ) * CGFloat(e1)))
        
        
        pointerLayer!.path = pointerPath.CGPath
        
        
        
    }
    
    

}
