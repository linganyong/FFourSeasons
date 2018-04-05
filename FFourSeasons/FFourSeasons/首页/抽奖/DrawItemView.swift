//
//  DrawItemView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class DrawItemView: UIView {
    let backImageView = UIImageView()
    let titleLabel = UILabel()
    
    //MARK:旋转点
    @IBInspectable var LGYAnchorPoint = CGPoint.init(x: 0.5, y: 1)
    
    //MARK:旋转点
    @IBInspectable var LGYTransformMakeRotationvValue:Float = 0.0 {
        didSet{
            transformMakeRotation()
        }
    }
    
    //MARK:绘制
    @IBInspectable var isDrawSubView:Bool = false{
        didSet{
            drawSubView(isDraw: isDrawSubView)
        }
    }
    
    //MARK:旋转
    func transformMakeRotation() -> Void {
        self.layer.anchorPoint = LGYAnchorPoint
        self.transform = CGAffineTransform(rotationAngle: CGFloat(LGYTransformMakeRotationvValue))
    }

    func drawSubView(isDraw:Bool) ->Void{
        if !isDraw{
            backImageView.removeFromSuperview()
            titleLabel.removeFromSuperview()
        }
        if backImageView.superview == nil && isDraw{
            self.addSubview(backImageView)
            self.addSubview(titleLabel)
            
            backImageView.backgroundColor = UIColor.blue
            //设置collectionView和pageControl的约束
            backImageView.snp.makeConstraints { (make) in
                make.top.equalTo(self.snp.top).offset(30)
                make.width.equalTo(40)
                make.height.equalTo(40)
                make.centerX.equalTo(self)
            }
            titleLabel.textAlignment = .center
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(backImageView.snp.bottom).offset(4)
                make.left.equalTo(self.snp.left).offset(20)
                make.right.equalTo(self.snp.right).offset(-20)
                make.height.greaterThanOrEqualTo(21)
            }
        }
    }
    
}
