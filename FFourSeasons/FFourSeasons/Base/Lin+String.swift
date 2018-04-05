//
//  Lin+StringMD5.swift
//  HuaXiaYiKeIosApp
//
//  Created by LGY  on 2018/1/6.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation

extension String {
    
    //MARK:32位md5加密
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
    //MARK:Range转NSRange
    func lgyNSRange(range: Range<String.Index>?) -> NSRange? {
        if range == nil{
            return nil
        }
        let utf16view = self.utf16
        if let from = range?.lowerBound.samePosition(in: utf16view), let to = range?.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    //MARK:NSRange转Range
    func lgyRange(nsRange: NSRange?) -> Range<String.Index>? {
        if nsRange == nil{
            return nil
        }
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: (nsRange?.location)!, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: (nsRange?.length)!, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
    
}
