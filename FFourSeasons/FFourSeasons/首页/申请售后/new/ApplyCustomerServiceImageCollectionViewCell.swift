//
//  ApplyCustomerServiceImageCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/12.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol ApplyCustomerServiceImageCollectionViewCellDelegate {
    func applyCustomerServiceImageCollectionViewCell(cell:ApplyCustomerServiceImageCollectionViewCell)->Void;
}

class ApplyCustomerServiceImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    var delegate:ApplyCustomerServiceImageCollectionViewCellDelegate?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.layer.masksToBounds = true
        deleteButton.isHidden = true
    }

    @IBAction func action(_ sender: UIButton) {
        delegate?.applyCustomerServiceImageCollectionViewCell(cell: self)
    }
}
