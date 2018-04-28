//
//  MCCycleCell.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/2.
//  Copyright © 2018年 LGY. All rights reserved.
//

import UIKit
import SnapKit

class LCycleCell: UICollectionViewCell {
    var imgView: UIImageView = UIImageView()
    
    func addImage(image:UIImage) -> Void {
        if self.viewWithTag(1000) == nil{
            imgView.tag = 1000
            addSubview(imgView)
            //设置collectionView和pageControl的约束
            imgView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(self.snp.right)
            }
//            ImgView.frame = self.frame
        }
        imgView.image = image
    }
    
    func addImageUrl(imageUrl:String) -> Void {
        
        if self.viewWithTag(1000) == nil{
            imgView.tag = 1000
            imgView.contentMode = .scaleToFill
            addSubview(imgView)
            //设置collectionView和pageControl的约束
            imgView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.bottom.equalTo(self.snp.bottom)
                make.right.equalTo(self.snp.right)
            }
            //            ImgView.frame = self.frame
        }
        if imageUrl.contains("http"){
            imgView.imageFromURL(imageUrl, placeholder: UIImage.init(named: "loading.png")!)
        }else{
            imgView.image = UIImage.init(named: imageUrl)
        }
        
    }
}

