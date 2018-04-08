//
//  Lin+UIImage.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContext(reSize);
//        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.mainScreen.scale);
        self.draw(in:CGRect(x: 0, y: 0, width: reSize.width, height:  reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}
