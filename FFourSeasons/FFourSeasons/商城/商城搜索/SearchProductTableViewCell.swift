//
//  MyHarvestTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class SearchProductTableViewCell: UITableViewCell {
 
    @IBOutlet weak var maginLeftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var line1Label: UILabel!

    @IBOutlet weak var line2Label: UILabel!
    var model:Goods?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.LGyCornerRadius = 15
     
        
        LGYTool.viewLayerShadowCornerRadius(view: backView, cornerRadius: 15) //添加阴影
    }

    func setDataScoure(imageUrl:String?,line1Str:String?,line2Str:String?) -> Void {
       
        if imageUrl != nil{
            productImageView.lGYImageFromURL(imageUrl: imageUrl!, placeholderImageName: "loading.png")
        }
        
        line1Label.text = line1Str
        line2Label.text = line2Str
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
