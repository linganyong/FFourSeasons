//
//  AddressTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/27.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol AddressTableViewCellDelegate {
    func addressTableViewCell(buttonKey:String,cell:AddressTableViewCell,model:Addresses?) ->Void
}

class AddressTableViewCell: UITableViewCell {
    var model:Addresses?
    var indexPath:IndexPath?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
      @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var extendButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate:AddressTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        LGYTool.viewLayerShadow(view: backView)
        LGYTool.viewLayerShadow(view: editButton)
        LGYTool.viewLayerShadow(view: deleteButton)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction private func action(_ sender: UIButton) {
        delegate?.addressTableViewCell(buttonKey: sender.LGYLabelKey!, cell: self, model: model)
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
    
    func editShow() -> Void {
        editButton.isHidden = false
        deleteButton.isHidden = false
        extendButton.setImage(UIImage.init(named: "下拉收起"), for: .normal)
    }
    
    func edithidden() -> Void {
        editButton.isHidden = true
        deleteButton.isHidden = true
        extendButton.setImage(UIImage.init(named: "下拉展开"), for: .normal)
    }
}
