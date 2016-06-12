//
//  StoreManager.swift
//  Protractor
//
//  Created by Peter Pomlett on 24/05/2016.
//  Copyright © 2016 Peter Pomlett. All rights reserved.
//
import StoreKit


class StoreManager: NSObject , SKProductsRequestDelegate, SKRequestDelegate {
    
        static let sharedInstance = StoreManager()
        private override init() {} //This prevents others from using the default '()' initializer for this class.

     let nc = NSNotificationCenter.defaultCenter()
    
  //Helper functions
    
    func loadInAppPurchases(){
        //setupIAP
        print(SKPaymentQueue.canMakePayments())
        if(SKPaymentQueue.canMakePayments()==true){
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
    
    
    
    func isIAPAllowed ()-> Bool{
        return SKPaymentQueue.canMakePayments()
    }
    
    
    
    func requestDidFinish(request: SKRequest) {
        print("DONE remove the spinners");
     nc.postNotificationName("IAPRequestDidFinish", object: nil)
    }
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error Fetching product information");
         nc.postNotificationName("IAPRequestFailed", object: nil)
        
        print(error.localizedDescription)
    }

    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        for product in myProduct{
            print ("product added")
            print(product.productIdentifier)
            
            print(product.localizedTitle)
         //   self.productTitle = product.localizedTitle
            print(product.localizedDescription)
          //  self.productDescription = product.localizedDescription
            print(product.price)
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = product.priceLocale
        //    self.productPrice = numberFormatter.stringFromNumber(product.price)
            
            
           // list.append(product as SKProduct)
        }
      //  self.storeButton.enabled = true
        
        
    }



}
