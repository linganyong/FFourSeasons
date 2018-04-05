//
//  LGYMaxCollectionViewFlowLayout.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/21.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LGYMaxCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var maxInteritemSpacing:CGFloat =  CGFloat(10000.0)
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        if maxInteritemSpacing < minimumInteritemSpacing-2 || (attributes?.count)! < 2{
            return attributes
        }
        
        
        for i in 1..<(attributes?.count)! {
            //当前attributes
            let currentLayoutAttributes: UICollectionViewLayoutAttributes? = attributes?[i]
            //上一个attributes
            let prevLayoutAttributes: UICollectionViewLayoutAttributes? = attributes?[i - 1]
            
            //判断同一个section,cell的orgin.y相同
            if currentLayoutAttributes?.indexPath.section == prevLayoutAttributes?.indexPath.section && currentLayoutAttributes?.frame.origin.y == prevLayoutAttributes?.frame.origin.y {
                //前一个cell的最右边位置
                let origin: CGFloat = (prevLayoutAttributes?.frame.origin.x)! + (prevLayoutAttributes?.frame.size.width)!
                //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
                //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
                if origin + maxInteritemSpacing + (currentLayoutAttributes?.frame.size.width)! < collectionViewContentSize.width {
                    var frame: CGRect? = currentLayoutAttributes?.frame
                    frame?.origin.x = origin + maxInteritemSpacing
                    currentLayoutAttributes?.frame = frame!
                }
            }
            
        }
        
        return attributes
    }
    
    
}
