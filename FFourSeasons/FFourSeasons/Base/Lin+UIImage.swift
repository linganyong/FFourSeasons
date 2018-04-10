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
//        UIGraphicsBeginImageContext(reSize);
        
        let scale = self.size.width/self.size.height
        var height = reSize.height
        var width = reSize.width
        if scale > 1{
            height = width/scale
        }else{
            width = height*scale
        }
        
        UIGraphicsBeginImageContextWithOptions(reSize,false,0.0);
        self.draw(in:CGRect(x: 0, y: 0, width:width, height:height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(width:CGFloat)->UIImage {
        //        UIGraphicsBeginImageContext(reSize);
        let scale = self.size.width/self.size.height
        let reSize = CGSize.init(width: width, height: width/scale)
        UIGraphicsBeginImageContextWithOptions(reSize,false,0.0);
        self.draw(in:CGRect(x: 0, y: 0, width: reSize.width, height:  reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    //MARK:透明部分填充颜色
    func maskWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        let rect = CGRect(origin: CGPoint.zero, size: size)
        color.setFill()
        context.fill(rect)
        context.setBlendMode(.copy)
        self.draw(in: rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    //MARK:生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
}
