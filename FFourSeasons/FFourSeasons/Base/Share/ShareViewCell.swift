//
//  ShareViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/10.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ShareViewCell: UICollectionViewCell {

    @IBOutlet weak var classImageView: UIImageView!
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    func setDataScoure(imageUrl:String?) -> Void {
        if imageUrl != nil && (imageUrl?.contains("http"))!{
             classImageView.imageFromURL(imageUrl!, placeholder: UIImage.init(named: "loading.png")!)
        }else if imageUrl != nil{
            classImageView.image = UIImage(named: imageUrl!)
        }else{
            classImageView.image = UIImage.init(named: "loading.png")
        }
    }

}
