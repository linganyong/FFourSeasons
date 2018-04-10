//
//  MainPageProductTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class MainPageProductTableViewCell: UITableViewCell {
    var model:Goods?
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var groundView: UIView!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line3Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    }
    
    func setModel(item:Goods) -> Void {
        model = item
        loginImageView.image = UIImage.init(named: "空心圆.png")
        productImageView.layer.masksToBounds = true
        setDataScoure(imageUrl: item.small_icon, line1Str: "当前推荐！", line2Str: item.title, line3Str:item.price)
    }
    
    func setDataScoure(imageUrl:String,line1Str:String,line2Str:String,line3Str:String) -> Void {
        line1Label.text = line1Str
        line2Label.text = line2Str
        line3Label.text = String(format: "￥%@", line3Str)
        productImageView.lGYImageFromURL(imageUrl: imageUrl, placeholderImageName: "loading.png")
      
        self.backgroundColor = UIColor.clear
        groundView.LGyCornerRadius = 10
        backView.LGyCornerRadius = 10
        LGYTool.viewLayerShadow(view: backView)
//        LGYTool.viewLayerShadowCornerRadius(view: backView,cornerRadius: 10) //添加阴影
        

    
    }
    
}
