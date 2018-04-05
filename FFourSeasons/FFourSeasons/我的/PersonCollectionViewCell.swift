//
//  PersonCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/2.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class PersonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataScoure(value: [String: String]?) -> Void {
        let title:String = (value?.keys.first)!
        let imageName:String = (value?[title])!
        menuTitleLabel.text = title
        menuImageView.image = UIImage(named: imageName)
    }
    
}
