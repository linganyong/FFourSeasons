//
//  AddressShowTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit


class AddressShowTableViewCell: UITableViewCell {
    var model:Addresses?
    
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.LGyCornerRadius = backView.LGyCornerRadius
        LGYTool.viewLayerShadow(view: shadowView)
        
    }
    
    func setModel(item:Addresses?) -> Void {
        if item == nil {
            return
        }
        model = item
        nameLabel.text = "收货人："+item!.name
        phoneLabel.text = item?.phone
        addressLabel.text = "地址：" + item!.located.replacingOccurrences(of: "/", with: "") + item!.address
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    

}
