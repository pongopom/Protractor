//
//  OneFingerRotationGesture.swift
//  cgtest
//
//  Created by Peter Pomlett on 04/10/2015.
//  Copyright © 2015 Peter Pomlett. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private let π = CGFloat(M_PI)
//
//public extension CGFloat {
//    var degrees:CGFloat {
//        return self * 180 / π;
//    }
//    var radians:CGFloat {
//        return self * π / 180;
//    }
//    var rad2deg:CGFloat {
//        return self.degrees
//    }
//    var deg2rad:CGFloat {
//        return self.radians
//    }
//    
//}
class OneFingerRotationGesture: UIGestureRecognizer {
    //MARK: Public Properties
    
    // midpoint for gesture recognizer
    internal var midPoint = CGPointZero
    
    // minimal distance from midpoint
    internal var innerRadius:CGFloat?
    
    // maximal distance to midpoint
    internal var outerRadius:CGFloat?
    
    // relative rotation for current gesture (in radians)
    internal var rotation:CGFloat? {
        if let currentPoint = self.currentPoint {
            if let previousPoint = self.previousPoint {
                var rotation = angleBetween(currentPoint, andPointB: previousPoint)
                
                if (rotation > π) {
                    rotation -= π*2
                } else if (rotation < -π) {
                    rotation += π*2
                }
                
                return rotation
            }
        }
        
        return nil
    }
    
    // absolute angle for current gesture (in radians)
    internal var angle:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(nowPoint)
        }
        
        return nil
    }
    
    // distance from midpoint
    internal var distance:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.distanceBetween(self.midPoint, andPointB: nowPoint)
        }
        
        return nil
    }
    
    //MARK: Private Properties
    
    // internal usage for calculations. (Please give us Access Modifiers, Apple!)
    private var currentPoint:CGPoint?
    private var previousPoint:CGPoint?
    
    //MARK: Public Methods
    
    // designated initializer
    internal init(midPoint:CGPoint, innerRadius:CGFloat?, outerRadius:CGFloat?, target:AnyObject, action:Selector) {
        super.init(target: target, action: action)
        
        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        
    }
    
    // convinience initializer if innerRadius and OuterRadius are not necessary
    internal convenience init(midPoint:CGPoint, target:AnyObject, action:Selector) {
        self.init(midPoint:midPoint, innerRadius:nil, outerRadius:nil, target:target, action:action)
    }
    
    
    //MARK: Private Methods
    
    private func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
    
    private func angleForPoint(point:CGPoint) -> CGFloat {
        var angle = -atan2(point.x - midPoint.x, point.y - midPoint.y) + π/2
        
        if (angle < 0) {
            angle += π*2;
        }
        
        return angle
    }
    
    private func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        return angleForPoint(pointA) - angleForPoint(pointB)
    }
    
    //MARK: Subclassed Methods
    
    override internal func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        super.touchesBegan(touches, withEvent: event!)
        
        if let touch = touches.first {
            currentPoint = touch.locationInView(self.view)
            
            var newState:UIGestureRecognizerState = .Began
            
            if let innerRadius = self.innerRadius {
                if distance < innerRadius {
                    newState = .Failed
                }
            }
            
            if let outerRadius = self.outerRadius {
                if distance > outerRadius {
                    newState = .Failed
                }
            }
            
            state = newState
        }
    }
    
    
    override internal func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        
        super.touchesMoved(touches, withEvent: event)
        if state == .Failed {
            return
        }
        if let touch = touches.first {
            currentPoint = touch.locationInView(self.view)
            previousPoint = touch.previousLocationInView(self.view)
            state = .Changed
            
        }
    }
    
    
    override internal func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        state = .Ended
        currentPoint = nil
        previousPoint = nil
    }
}
