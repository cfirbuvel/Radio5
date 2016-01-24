//
//  AppsViewController.swift
//  Radio5
//
//  Created by Cfir Shor on 13/12/2015.
//  Copyright © 2015 Cfir Shor. All rights reserved.
//

import UIKit
import StoreKit

class AppsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var appsArray: [Product] = []
    var memoryName = []
    var memoryDetail = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.appsArray = Product.readProductsArray()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (self.tableView.respondsToSelector("setSeparatorInset:")){
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        if (self.tableView .respondsToSelector("setLayoutMargins:")){
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        // 1
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.barStyle = UIBarStyle.Default
        // 3
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        // 4
        let image = UIImage(named: "radio5_logo_nav")
        imageView.image = image
        // 5
        navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (cell .respondsToSelector("setSeparatorInset:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
        if (cell .respondsToSelector("setLayoutMargins:")){
            cell.separatorInset = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        
        return appsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("appCell", forIndexPath: indexPath) as! AppsCell
        
        cell.configureWithProduct(appsArray[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let dict = appsArray[indexPath.row]
        showProductVCWithItunesID(dict.productItunesId)

    }
    
    @IBAction func appButtonTapped(sender: AppButton) {
        
        showProductVCWithItunesID(sender.itunesId)
    }

    func showProductVCWithItunesID(itunesID : String!){
        if itunesID == nil{
            return
        }
        let vc: SKStoreProductViewController = SKStoreProductViewController()
        let params = [
            SKStoreProductParameterITunesItemIdentifier:itunesID,
        ]
        vc.delegate = self
        vc.loadProductWithParameters(params) { (success, error) -> Void in
            self.presentViewController(vc, animated: true) { () -> Void in }
        }

    }

    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
