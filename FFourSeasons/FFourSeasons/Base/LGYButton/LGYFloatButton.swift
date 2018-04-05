//
//  LGButton.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/2.
//  Copyright © 2018年 LGY. All rights reserved.
//

import UIKit
@IBDesignable
class LGFloatButton: UIButton {
   
    var backView:UIView?
    var isMoved:Bool = false
    
    @IBInspectable var dockable:Bool = false //松手移动到边，默认松手移动到哪里就是哪里
    
    @IBInspectable var LGYShadowColor:UIColor = UIColor.clear{
        didSet{
            viewLayerShadowCornerRadius(color:LGYShadowColor.cgColor)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch = touches.first
        //本次触摸点
        let current: CGPoint? = touch?.location(in: self)
        //上次触摸点
        let previous: CGPoint? = touch?.previousLocation(in: self)
        var center: CGPoint = self.center
        //中心点移动触摸移动的距离
        center.x += (current?.x)! - (previous?.x)!
        center.y += (current?.y)! - (previous?.y)!
        //限制移动范围
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let screenHeight: CGFloat = UIScreen.main.bounds.size.height
        let xMin: CGFloat = frame.size.width * 0.5
        let xMax: CGFloat = screenWidth - xMin
        let yMin: CGFloat = frame.size.height * 0.5 + 64
        let yMax: CGFloat = screenHeight - frame.size.height * 0.5 - 49
        if center.x > xMax {
            center.x = xMax
        }
        if center.x < xMin {
            center.x = xMin
        }
        if center.y > yMax {
            center.y = yMax
        }
        if center.y < yMin {
            center.y = yMin
        }
        self.center = center
        self.backView?.center = center
        
        //判断在移动
        self.isMoved = true

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoved {
            //如果没有移动，则调用父类方法，触发button的点击事件
            super.touchesEnded(touches, with: event)
        }
        self.isMoved = false
        //关闭高亮状态
        self.isHighlighted = false
        
        if !self.dockable{
            return
        }
        //回到一定范围
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let x: CGFloat = frame.size.width * 0.5
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            var center: CGPoint = self.center
            center.x = self.center.x > screenWidth * 0.5 ? screenWidth - x : x
            self.center = center
            self.backView?.center = center
        })
    }
    
    //MARK:统一设置阴影
    func viewLayerShadowCornerRadius(color:CGColor) ->Void{
        if backView == nil && self.superview != nil{
            backView = UIView()
            backView?.backgroundColor = UIColor.white
            self.superview?.insertSubview(backView!, belowSubview: self)
            backView?.snp.makeConstraints({ (make) in
                make.centerX.equalTo(self.snp.centerX)
                make.centerY.equalTo(self.snp.centerY)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(self.snp.height)
            })
        }
        
        //添加阴影
        backView?.layer.shadowOpacity = 1 //不透明图
        backView?.layer.shadowColor = color
        backView?.layer.shadowOffset = CGSize(width: 0, height: 0) // 设置阴影的偏移量
        backView?.layer.shadowRadius = 3
        backView?.layer.cornerRadius = CGFloat(self.layer.cornerRadius)
        backView?.clipsToBounds = false //添加此句展示效果
    }
    
    override func removeFromSuperview() {
        backView?.removeFromSuperview()
        super.removeFromSuperview()
    }
}

