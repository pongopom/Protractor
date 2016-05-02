//
//  ShopViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 19/02/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    
    var pTitle: String?
    var pDescription: String?
    var pPrice: String?

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.titleLabel.text = pTitle
        self.descriptionLabel.text = pDescription
        self.priceLabel.text = pPrice
        
    }
    
    
    
    
    @IBAction func makePurchase(sender: AnyObject) {
        
        
    }
    
    @IBAction func restorePurchase(sender: AnyObject) {
        
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
       self.dismissViewControllerAnimated(true, completion: nil)  
    }

    
    
    
}
