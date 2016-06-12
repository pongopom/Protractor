//
//  AngleType.swift
//  Protractor
//
//  Created by Peter Pomlett on 26/01/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import Foundation

func typeOfAngleFor( degrees: Float) ->String{
    
    var deg = degrees
    
    if deg <= 0 {
        deg = deg * -1
    }
    var typeOfAngle = ""
    if (deg < 89.5) && (deg > 0.5){
     typeOfAngle = "Acute"
    }
    else if (deg > 89.5) && (deg < 90.5){
        typeOfAngle = "Right"
    }
    else if (deg > 90.5) && (deg < 179.5){
      typeOfAngle = "Obtuse"
    }
    else if (deg > 179.5) && (deg < 180.5){
        typeOfAngle = "Straight"
    }
    else if (deg > 180.5) && (deg < 359.5){
        typeOfAngle = "Reflex"
    }
    else if (deg > 359.5) {
        typeOfAngle = "Full Rotation"
    }
    else if (deg < 0.5) {
        typeOfAngle = "Zero"
    }
    return typeOfAngle
}