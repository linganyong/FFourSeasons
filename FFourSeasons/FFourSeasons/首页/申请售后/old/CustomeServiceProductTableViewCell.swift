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
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDataScoure(name:String,priceStr:String,countStr:String,imageUrl:String?) -> Void {
        productNameLabel.text = name
        productPriceLabel.text = priceStr
        productCountLabel.text = countStr
        if imageUrl != nil {
            productImageView.imageFromURL(imageUrl!, placeholder: UIImage(named:"loading.png")!)
        }else{
            productImageView.image = UIImage(named:"loading.png")
        }
    }
    
}
