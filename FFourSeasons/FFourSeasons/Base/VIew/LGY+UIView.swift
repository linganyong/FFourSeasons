//
//  LGY+UIView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
private var LGyCornerRadiusKey: Float?

extension UIView {

    //MARK:位IB设置圆角
   @IBInspectable var LGyCornerRadius:Float {
        get {
            if objc_getAssociatedObject(self, &LGyCornerRadiusKey)  == nil {
                return 0.0
            }
            return (objc_getAssociatedObject(self, &LGyCornerRadiusKey) as? Float)!
        }
        set(newValue) {
            objc_setAssociatedObject(self, &LGyCornerRadiusKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            layer.cornerRadius = CGFloat(newValue)
            layer.masksToBounds = true
        }
    }
    
    //MARK:设置部分圆角
    func addCorners(corners:UIRectCorner,cornerRadii:CGSize) -> Void {
        let roundes = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let shape = CAShapeLayer.init()
        shape.path = roundes.cgPath
        self.layer.mask = shape
    }
    
   

}
/*
 #import "UIView+LSCore.h"
 @implementation UIView (LSCore)
 #pragma mark - 设置部分圆角
 /**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
 - (void)addRoundedCorners:(UIRectCorner)corners
 withRadii:(CGSize)radii {
 
 UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
 CAShapeLayer* shape = [[CAShapeLayer alloc] init];
 [shape setPath:rounded.CGPath];
 
 self.layer.mask = shape;
 }
 
 /**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
 - (void)addRoundedCorners:(UIRectCorner)corners
 withRadii:(CGSize)radii
 viewRect:(CGRect)rect {
 
 UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
 CAShapeLayer* shape = [[CAShapeLayer alloc] init];
 [shape setPath:rounded.CGPath];
 
 self.layer.mask = shape;
 }
 @end

 */
