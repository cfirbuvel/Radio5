//
//  AppsCell.swift
//  Radio5
//
//  Created by Cfir Shor on 13/12/2015.
//  Copyright © 2015 Cfir Shor. All rights reserved.
//

import UIKit

class AppsCell: UITableViewCell {

    @IBOutlet weak var actionButton: AppButton!
    @IBOutlet weak var appCellImageView: UIImageView!
    @IBOutlet weak var appCellNameLabel: UILabel!
    @IBOutlet weak var appCellDescriptionLabel: UILabel!
    
    func configureWithProduct(p : Product){
        appCellImageView.image = UIImage(named: p.productImageName!)
        appCellNameLabel.text = p.productName!
        appCellDescriptionLabel.text = p.productDescription!
        
        actionButton.itunesId = p.productItunesId
        
    }

}
