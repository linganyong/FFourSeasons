//
//  AllClassCollectionViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/10.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AllClassCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var classImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func setDataScoure(imageUrl:String?,name:String) -> Void {
        if imageUrl != nil && (imageUrl?.contains("http"))!{
             classImageView.imageFromURL(imageUrl!, placeholder: UIImage.init(named: "loading.jpg")!)
        }else{
            classImageView.image = UIImage.init(named: "loading.jpg")
        }
        nameLabel.text = name
    }

}
