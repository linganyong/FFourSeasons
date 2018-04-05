//
//  APPGuideViewCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class APPGuideViewCell: UICollectionViewCell {
    var ImgView: UIImageView = UIImageView()
    
    func addImage(image:UIImage) -> Void {
        if self.viewWithTag(1000) == nil{
            ImgView.tag = 1000
            addSubview(ImgView)
            //设置collectionView和pageControl的约束
            ImgView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(self.snp.right)
            }
        }
        ImgView.image = image
    }
}
