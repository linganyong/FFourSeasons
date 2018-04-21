//
//  IntegralShopTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol IntegralShopTableViewCellDelegate {
    func integralShopTableViewCellButtonAction(cell:IntegralShopTableViewCell)
}

class IntegralShopTableViewCell: UITableViewCell {
 
    @IBOutlet weak var canExchangeImageView: UIImageView!
    @IBOutlet weak var maginLeftLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginTopLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var maginBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var line3Label: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    var myDelegate:IntegralShopTableViewCellDelegate?
    var model:Goods?
    override func awakeFromNib() {
        super.awakeFromNib()
     
      
        LGYTool.viewLayerShadow(view: backView)
        LGYTool.viewLayerShadow(view: buttonRight,color: UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1).cgColor,  shadowRadius: 3) //添加阴影
    }

    func setDataScoure(item:Goods,delegate:IntegralShopTableViewCellDelegate?) -> Void {
        model = item
        if model?.small_icon != nil{
            productImageView.lGYImageFromURL(imageUrl: model!.small_icon!, placeholderImageName: "loading.png")
        }else{
             productImageView.image = nil
        }
        if item.exchange == 0{
            canExchangeImageView.isHidden = true
        }else{
            canExchangeImageView.isHidden = false
        }
        line1Label.text = model?.title
        line3Label.text = String.init(format: "所需积分 %@", model!.price)
        myDelegate = delegate
    }
    
    @IBAction func action(_ sender: UIButton) {
        myDelegate?.integralShopTableViewCellButtonAction(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
