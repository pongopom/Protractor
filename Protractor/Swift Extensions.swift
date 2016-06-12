//
//  Swift Extensions.swift
//  Protractor
//
//  Created by Peter Pomlett on 06/05/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import Foundation
import UIKit

public extension Float {
    var degreesToRadians : Float {
        return Float(self) * Float(M_PI) / 180.0
    }
}


private let π = CGFloat(M_PI)
public extension CGFloat {
    var degrees:CGFloat {
        return self * 180 / π;
    }
    var radians:CGFloat {
        return self * π / 180;
    }
    var rad2deg:CGFloat {
        return self.degrees
    }
    var deg2rad:CGFloat {
        return self.radians
    }
    
}