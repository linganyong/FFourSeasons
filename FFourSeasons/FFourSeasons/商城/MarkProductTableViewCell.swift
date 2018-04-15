//
//  MainPageProductTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol MarkProductTableViewCellDelegate {
    func markProductTableViewCell(cell:MarkProductTableViewCell)
}

class MarkProductTableViewCell: UITableViewCell {
    public var model:Goods?
    @IBOutlet weak var loLabel: UILabel!
    @IBOutlet weak var loImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var groundView: UIView!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line3Label: UILabel!
    var delegate:MarkProductTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    }
    
    func setModel(item:Goods) -> Void {
        model = item
        var str:String?
        if item.status == 1{
            str = "新"
        }
        setDataScoure(imageUrl: item.small_icon,line1Str: item.title, line2Str: item.profile, line3str:String(format: "￥%@",(item.price)!), loStr: str)
    }
    
    @IBAction func action(_ sender: UIButton) {
        delegate?.markProductTableViewCell(cell: self)
        
    }
    
    func setDataScoure(imageUrl:String?,line1Str:String?,line2Str:String?,line3str:String?,loStr:String?) -> Void {
        line1Label.text = line1Str
        line2Label.text = line2Str
        line3Label.text = line3str
        if loStr == nil || loStr?.count == 0 {
            loImage.isHidden = true
            loLabel.text = ""
        }else{
            loImage.isHidden = false
            loLabel.text = loStr
        }
        productImageView.layer.masksToBounds = true
        if imageUrl != nil  && (imageUrl?.contains("http"))!{
            productImageView.lGYImageFromURL(imageUrl: imageUrl!, placeholderImageName: "loading.png")
        }
        self.backgroundColor = UIColor.clear
        groundView.LGyCornerRadius = 10
        
        LGYTool.viewLayerShadowCornerRadius(view: backView,cornerRadius: 10) //添加阴影
        

    
    }
    
}
