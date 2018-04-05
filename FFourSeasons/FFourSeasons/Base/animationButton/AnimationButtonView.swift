//
//  AnimationButtonView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AnimationButtonView: UIView,CAAnimationDelegate {
    
    let back1View = UIView()
    let back2View = UIView()
    let button = UIButton()
 
    
    //MARK:设置文字
    @IBInspectable var buttonText:String {
        get {
            return self.buttonText
        }
        set(newValue) {
            self.button.setTitle(newValue, for: .normal)
        }
    }
    
    //MARK:设置字体颜色
    @IBInspectable var textColor:UIColor {
        get {
            return self.textColor
        }
        set(newColor) {
            self.button.setTitleColor(newColor, for: .normal)
        }
    }
    
    //MARK:设置字体大小
    @IBInspectable var textFontSize:CGFloat {
        get {
            return self.textFontSize
        }
        set(newSize) {
            self.button.titleLabel?.font = UIFont.systemFont(ofSize: newSize)
        }
    }
    
    func setStyle() -> Void {
        addLGYSubview()
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents){
        self.button.addTarget(target, action: action, for: controlEvents)
    }
    
    func addLGYSubview() {
        addSubview(back1View)
        addSubview(back2View)
        addSubview(button)
        
        back1View.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(-8)
            make.bottom.equalTo(self.snp.bottom).offset(8)
            make.left.equalTo(self.snp.left).offset(-8)
            make.right.equalTo(self.snp.right).offset(8)
        }
        
        back2View.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.left.equalTo(self.snp.left).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
        }
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        self.layer.masksToBounds  = false
        
        back1View.backgroundColor = UIColor.white
        back1View.alpha = 0.5
        
        back2View.backgroundColor = UIColor.white
        back2View.alpha = 0.6
        
        back1View.LGyCornerRadius = self.LGyCornerRadius+8
        back2View.LGyCornerRadius = self.LGyCornerRadius
        button.LGyCornerRadius = self.LGyCornerRadius
      
        animiationAction()
    }
   
    func back1ViewAnimation() {
        // 设定为缩放
        let animation = CABasicAnimation(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 1.2
        // 重复次数(无限)
        animation.repeatCount = 1
        animation.autoreverses = true
        // 动画结束时执行逆动画
        // 缩放倍数
        animation.fromValue = 1
        // 开始时的倍率
        animation.toValue = 1.25
        animation.delegate = self
        // 结束时的倍率
        // 添加动画
        back1View.layer.add(animation, forKey: "scale-layer")
    }

    func back2ViewAnimation() {
        // 设定为缩放
        let animation = CABasicAnimation(keyPath: "transform.scale")
        // 动画选项设定
        animation.duration = 1.5
        // 重复次数(无限)
        animation.repeatCount = 1
        animation.autoreverses = true
        // 动画结束时执行逆动画
        // 缩放倍数
        animation.fromValue = 1
        // 开始时的倍率
        animation.toValue = 1.25
        animation.delegate = self
        // 结束时的倍率
        // 添加动画
        back2View.layer.add(animation, forKey: "scale-layer")
    }
    
    func animiationAction() -> Void {
        back1ViewAnimation()
        back2ViewAnimation()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.duration == 1.5{
            animiationAction()
        }
    }
    


}
