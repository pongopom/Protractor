//
//  KeyPadViewController.swift
//  Protractor
//
//  Created by Peter Pomlett on 10/01/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//

import UIKit

protocol KeyPadViewControllerDelegate{
    func slideOutVC()
    
}


class KeyPadViewController: UIViewController {
    var delegate:KeyPadViewControllerDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("keyViewHasLoaded")
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
        self.delegate.slideOutVC()
        print("go back button")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
