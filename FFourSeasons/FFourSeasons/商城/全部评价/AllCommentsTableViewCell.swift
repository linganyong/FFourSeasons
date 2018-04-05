//
//  AllCommentsTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AllCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //Shadow 0 for 矩形 8 拷贝
        LGYTool.viewLayerShadow(view: backView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
