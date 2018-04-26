//
//  VerificationCodeCountdownButton.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/26.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class VerificationCodeCountdownButton: UIButton {
    var allCount = -1
    var countLabel = UILabel()
    private var timer:Timer?
    var defaultText:String?
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if allCount > 0{
            return false
        }
        return true
    }
   
    
    func setRun(count:Int,time:Double)->Void{
        allCount = count
        countLabel.text = "获取验证码（\(allCount)s）"
        countLabel.frame = self.bounds
        countLabel.textColor = self.titleLabel?.textColor
        countLabel.font = UIFont.systemFont(ofSize: 11)
        countLabel.textAlignment = .center
        countLabel.backgroundColor = UIColor.clear
        self.addSubview(countLabel)
        defaultText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        timer = Timer(timeInterval: time, target: self, selector: #selector(changeCountLabelText), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
        
    }
    
    @objc func changeCountLabelText()->Void{
        allCount -= 1
        countLabel.text = "获取验证码（\(allCount)s）"
        if allCount <= 0{
            timer?.invalidate()
            timer = nil
             self.setTitle(defaultText, for: .normal)
            countLabel.removeFromSuperview()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
