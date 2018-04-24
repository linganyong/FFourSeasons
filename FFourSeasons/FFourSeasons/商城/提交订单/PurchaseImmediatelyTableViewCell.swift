//
//  PurchaseImmediatelyTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class PurchaseImmediatelyTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewMaginLeftLC: NSLayoutConstraint!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        productImageView.layer.masksToBounds = true
    }
    
    func setDataScoure(name:String,priceStr:String,countStr:String,imageUrl:String?) -> Void {
        productNameLabel.text = name
        
        productPriceLabel.text = priceStr
        productCountLabel.text = countStr
        if imageUrl != nil{
            productImageView.imageFromURL(imageUrl!, placeholder: UIImage.init(named: "loading.png")!)
        }else{
            productImageView.image = UIImage.init(named: "loading.png")
        }
    }
    
}
