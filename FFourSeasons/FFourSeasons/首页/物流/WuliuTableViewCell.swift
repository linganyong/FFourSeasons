//
//  WuliuTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class WuliuTableViewCell: UITableViewCell {

    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
