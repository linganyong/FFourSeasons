//
//  Lin+ss.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

 extension UILabel {
    
    
    func changeRange(range:NSRange,color:UIColor?,textSize:CGFloat){
        let text = NSMutableAttributedString(string: self.text!)
        if let co = color{
            text.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: co, range: range)
        }
        if textSize > 0{
            text.addAttribute(kCTFontAttributeName as NSAttributedStringKey, value: UIFont.systemFont(ofSize: textSize), range: range)
        }
        self.attributedText = text
    }
    

}
