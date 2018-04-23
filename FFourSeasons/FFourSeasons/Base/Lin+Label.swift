//
//  Lin+ss.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

 extension UILabel {
    
    //MARK:设置部分字体颜色
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
    
/**
     *  设置行间距和字间距
     *  @param lineSpace 行间距
     *  @return 富文本
     */
func setlineSpace(lineSpace: CGFloat) -> Void {
    let attributedString:NSMutableAttributedString = NSMutableAttributedString(string:self.text!)
    let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpace //大小调整
//    attributedString.addAttributes(<#T##attrs: [NSAttributedStringKey : Any]##[NSAttributedStringKey : Any]#>, range: <#T##NSRange#>)
    attributedString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value: paragraphStyle, range: NSMakeRange(0, self.text!.count))
    self.attributedText = attributedString
}

}
