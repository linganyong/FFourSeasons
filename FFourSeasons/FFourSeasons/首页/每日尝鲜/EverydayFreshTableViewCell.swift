//
//  EverydayFreshTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class EverydayFreshTableViewCell: UITableViewCell {

    @IBOutlet weak var productDetailButtonBackView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LGYTool.viewLayerShadow(view: backView)
        LGYTool.viewLayerShadowShadowOffsetHeight(view: productImageView)
        productDetailButtonBackView.LGyCornerRadius = productDetailButton.LGyCornerRadius
        LGYTool.viewLayerShadow(view: productDetailButtonBackView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func dataScoure(imageUrl:String,name:String,des:String) -> Void {
        productImageView.imageFromURL(imageUrl, placeholder: UIImage.init(named: "loading.jpg")!)
            productNameLabel.text = name
        productDesLabel.text = des
    }
    
    
}
