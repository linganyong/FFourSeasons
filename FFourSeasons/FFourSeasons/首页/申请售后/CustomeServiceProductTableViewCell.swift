//
//  CustomeSeviceTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class CustomeServiceProductTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewMaginLeftLC: NSLayoutConstraint!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataScoure(name:String,priceStr:String,countStr:String) -> Void {
        productNameLabel.text = name
        productPriceLabel.text = priceStr
        productCountLabel.text = countStr
    }
    
}
