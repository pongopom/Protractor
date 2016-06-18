//
//  UpgradeTableviewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 23/05/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import UIKit


protocol UpgradeTableviewControllerDelegate{
    func buyScale()
    func buy360()
    func  restoreProducts()
    func upgradeVCDismissed()
}





class UpgradeTableviewController: UITableViewController {
   
    var delegate: UpgradeTableviewControllerDelegate! = nil
    @IBOutlet weak var heading360: UILabel!
    @IBOutlet weak var description360: UILabel!
    @IBOutlet weak var price360: UILabel!
    @IBOutlet weak var buyButton360: UIButton!
    
    @IBOutlet weak var headingType: UILabel!
    @IBOutlet weak var descriptionType: UILabel!
    @IBOutlet weak var priceType: UILabel!
    @IBOutlet weak var buyButtonType: UIButton!
    
    var scaleTitle: String!
    var scaleDescription: String!
    var scalePrice: String!
    
    var three60Title: String!
    var three60Description: String!
    var three60Price: String!
    var showTypeButton: Bool!
    var show360Button: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heading360.text = three60Title
        self.description360.text = three60Description
        self.price360.text = three60Price
        self.headingType.text = scaleTitle
        self.descriptionType.text = scaleDescription
        self.priceType.text = scalePrice
        if showTypeButton == false{
            self.buyButtonType.enabled = false
        }
        if show360Button == false{
            self.buyButton360.enabled = false
        }
    }

    
    
    @IBAction func restorePutchases(sender: AnyObject) {
        
        self.delegate.restoreProducts()
        
    }
    
    @IBAction func buy360(sender: UIButton) {
        
        self.delegate.buy360()
        sender.enabled = false
    }
    
    
    @IBAction func buyScales(sender: UIButton) {
        
       self.delegate.buyScale()
        sender.enabled = false
    }
    
    
    
    
    
    @IBAction func done(sender: AnyObject) {
        
       self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate.upgradeVCDismissed()
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        
    }
    
    
    
    
    
    
    
    
    
}
