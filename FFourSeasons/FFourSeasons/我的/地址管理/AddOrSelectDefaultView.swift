//
//  AddOrSelectDefaultView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/19.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias AddOrSelectDefaultViewBlock = (_ key:Int,_ view:AddOrSelectDefaultView)->Void

class AddOrSelectDefaultView: UIView {
    let button1 = UIButton()
    let button2 = UIButton()
    var block:AddOrSelectDefaultViewBlock?
    
    class func show(callblock:AddOrSelectDefaultViewBlock?) ->Void{
        let view = AddOrSelectDefaultView()
        view.frame = UIScreen.main.bounds
        view.block = callblock
        view.addSubview(view.button1)
        view.addSubview(view.button2)
        
        let width = 150.0
        let height = 50.0
        let maginX =  Double((UIScreen.main.bounds.size.width - 150)/2)
        let maginTop = 259.0
        let maginButton = 20.0
        view.button1.frame = CGRect(x: maginX, y: maginTop, width: width, height: height)
        view.button2.frame = CGRect(x: maginX, y: maginTop+height+maginButton, width: width, height: height)

        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        view.button1.backgroundColor = UIColor.black
        view.button2.backgroundColor = UIColor.black
        view.button1.layer.cornerRadius = 10
        view.button2.layer.cornerRadius = 10
        view.button1.backgroundColor = UIColor.white
        view.button2.backgroundColor = UIColor.white
        view.button1.setTitle("设置默认地址", for: .normal)
        view.button2.setTitle("添加收货地址", for: .normal)
        view.button1.setTitleColor(UIColor.black, for: .normal)
        view.button2.setTitleColor(UIColor.black, for: .normal)
        view.button1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.button2.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        view.button1.tag = 1001
        view.button2.tag = 1002
        //点击响应
        view.button1.addTarget(view, action: #selector(action(button:)), for: .touchUpInside)
        view.button2.addTarget(view, action: #selector(action(button:)), for: .touchUpInside)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(cancle)))
        
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
    @objc func cancle() -> Void {
        self.removeFromSuperview()
    }
    
    @objc func action(button:UIButton) -> Void {
        block?(button.tag - 1000,self)
    }
    
}
