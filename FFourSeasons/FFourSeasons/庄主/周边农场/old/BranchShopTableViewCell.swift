//
//  BranchShopTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class BranchShopTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        LGYTool.viewLayerShadow(view: backView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
