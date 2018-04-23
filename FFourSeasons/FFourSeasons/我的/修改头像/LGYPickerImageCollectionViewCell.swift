//
//  LGYPickerImageCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LGYPickerImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var width: NSLayoutConstraint!
    @IBOutlet weak var prictureImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       prictureImageView.layer.masksToBounds = true
    }

}
