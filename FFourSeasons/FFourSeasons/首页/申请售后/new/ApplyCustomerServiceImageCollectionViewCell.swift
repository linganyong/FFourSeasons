//
//  ApplyCustomerServiceImageCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/12.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ApplyCustomerServiceImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.layer.masksToBounds = true
    }

}
