//
//  LGYPickerImageTableViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LGYPickerImageTableViewCell: UITableViewCell {

    @IBOutlet weak var prictureCountLabel: UILabel!
    @IBOutlet weak var pricturePathLabel: UILabel!
    @IBOutlet weak var prictureTitleLabel: UILabel!
    @IBOutlet weak var prictureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
