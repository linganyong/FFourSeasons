//
//  LuchDrawView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
//typealias blockLogin1=(obj_bolck:String)->Void
typealias LuckDrawAnimationFinish = (_ anim:CAAnimation,_ isFinish:Bool)->Void

class LuckDrawView: UIView,CAAnimationDelegate {
    private  let animation = CABasicAnimation(keyPath: "transform.rotation")
    private let backImageView = UIImageView()
    private var drawNameArray = Array<String>()
    private let startButton = UIButton()
    private var isFirst = true
    private var luckDrawAnimationFinish:LuckDrawAnimationFinish?
    
    //MARK:设置抽奖的奖品名称
    func drawArray(drawName:Array<String>) -> Void {
        //移除原来多余的view
        for i in drawNameArray.count...drawName.count{
            let item = self.viewWithTag(1000+i)
            item?.removeFromSuperview()
        }
        
        if backImageView.superview == nil{
            self.addSubview(backImageView)
            backImageView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top)
                make.bottom.equalTo(self.snp.bottom)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
            }
            backImageView.image = UIImage(named: "抽奖转盘.png")
            
        }
        //设置新的数据
        drawNameArray = drawName
        setUpItemView(drawName: drawNameArray)
    }
    
    //MARK:设置奖项View
    private func setUpItemView(drawName:Array<String>) -> Void {
        for i in 0...drawName.count-1{
            var item = self.viewWithTag(1000+i) as? DrawItemView
            let itemWidth  = CGFloat(100.0)
            let transformMakeRotationvValue = Float(2.0)*Float(M_PI)/Float(drawName.count)
            if item == nil{
                item = DrawItemView()
                item?.tag = 1000+i
                self.addSubview(item!)
                item?.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(self.snp.centerX)
                    //奇怪的问题，需要添加.offset(0)旋转中心才正确
                    make.centerY.equalTo(self.snp.centerY).offset(0)
                    make.width.equalTo(itemWidth)
                    make.height.equalTo(self.snp.height).multipliedBy(0.5)
                })
            }
            item?.titleLabel.text = drawName[i]
            item?.titleLabel.numberOfLines = 2
            item?.titleLabel.font = UIFont.systemFont(ofSize: 10)
//            item?.backgroundColor = UIColor.black
            item?.isDrawSubView = true
            self.layoutSubviews()
            item?.LGYTransformMakeRotationvValue = transformMakeRotationvValue*Float(i)
        }
        
    }
    
    //MARK:做旋转动画
    func startLuckDrawAnimationValue(value:Float,finishBlack:@escaping LuckDrawAnimationFinish) -> Void {
        
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        let time = Float(2.0)*Float(M_PI)*5 - Float(2.0)*Float(M_PI)/Float(drawNameArray.count)*value
        animation.toValue = time
        animation.duration = CFTimeInterval(time/5)
        NSLog("%.2lf", value)
        
        //保持动画位置
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        //        animation.autoreverses = false
        animation.repeatCount = 0
        animation.delegate = self
        self.layer.add(animation, forKey: "555")
        luckDrawAnimationFinish = finishBlack
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.luckDrawAnimationFinish?(anim,flag)
        }
    }

 
}
