//
//  ITunesProduct.swift
//  Radio5
//
//  Created by Cfir Shor on 13/12/2015.
//  Copyright © 2015 Cfir Shor. All rights reserved.
//

import UIKit

class Product {
    
    let productName : String?
    let productDescription : String?
    let productImageName : String?
    let productItunesId : String?
    
    init(dict : NSDictionary) {
        self.productName = dict["name"]as? String
        self.productDescription = dict["description"]as? String
        self.productImageName = dict["image_name"]as? String
        self.productItunesId = dict["itunes_id"]as? String
    }
    
    class func readProductsArray() -> [Product]
    {
        var finalArray = [Product]()
        var myDict: NSArray?
        if let path = NSBundle.mainBundle().pathForResource("apps", ofType: "plist") {
            myDict = NSArray(contentsOfFile: path)
        }
        if let dict = myDict {
            for item in dict{
                let temDict = item as! NSDictionary
//                print("plist array is: \(temDict)")
                finalArray.append(Product(dict: temDict))
            }
        }
//        print("finalArray is: \(finalArray)")
        return finalArray
    }

}
