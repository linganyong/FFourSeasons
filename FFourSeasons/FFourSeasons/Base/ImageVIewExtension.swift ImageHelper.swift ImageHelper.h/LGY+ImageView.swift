//
//  LGY+ImageView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    //MARK:设置图片，此方法一般调用第三方类库，方便后期修改第三方
    func lGYImageFromURL(imageUrl:String, placeholderImageName:String){
        //第三方类库方法
        imageFromURL(imageUrl, placeholder: UIImage(named: placeholderImageName)!)
    }
}
