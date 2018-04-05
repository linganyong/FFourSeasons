//
//  Lin+StringMD5.swift
//  HuaXiaYiKeIosApp
//
//  Created by LGY  on 2018/1/6.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation

extension String {
    
//    var MD5: String {
//        let cString = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let length = CUnsignedInt(
//            self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//        )
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(
//            Int(CC_MD5_DIGEST_LENGTH)
//        )
//        
//        CC_MD5(cString!, length, result)
//        
//        return String(format:
//            "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//                      result[0], result[1], result[2], result[3],
//                      result[4], result[5], result[6], result[7],
//                      result[8], result[9], result[10], result[11],
//                      result[12], result[13], result[14], result[15])
//    }
    
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
    

}
