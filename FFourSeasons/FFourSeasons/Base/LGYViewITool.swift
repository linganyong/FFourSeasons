//
//  LGYViewITool.swift
//  Created by LGY  on 2018/1/8.
//  Copyright © 2018年 . All rights reserved.
//

import UIKit


class LGYViewITool: NSObject {
    
    //MARK:设置圆角
    class func viewCornerRadius(_view:UIView, _cornerRadius:CGFloat) -> UIView {
        _view.layer.cornerRadius = _cornerRadius;
        _view.layer.masksToBounds = true;
        return _view
    }
    
    class func viewCornerRadius(_view:UIView, _cornerRadius:CGFloat,_borderWidth:CGFloat,_borderColor:UIColor?) -> UIView {
        _view.layer.cornerRadius = _cornerRadius;
        _view.layer.masksToBounds = true;
        _view.layer.borderWidth = _borderWidth
        if _borderColor != nil{
            _view.layer.borderColor = _borderColor?.cgColor
        }
        return _view
    }
    
}
