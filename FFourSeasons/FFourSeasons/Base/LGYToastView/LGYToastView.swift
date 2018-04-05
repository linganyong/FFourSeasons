//
//  LGYToastView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias LGYToastViewCallBlock = () ->Void

class LGYToastView: UILabel {
    
    static let defaultToastView = LGYToastView()
    let isCanCancle = true
    private var callBlock:LGYToastViewCallBlock?
    private var timerShow:Timer?
    var timeInterval = Float(3.0)
    
    //MARK:模仿Android toast 弹出提示
    class func show(message:String,timeInterval:Float,block:LGYToastViewCallBlock?) ->LGYToastView{
        let view = LGYToastView.defaultToastView
        view.timeInterval = timeInterval
        view.callBlock = block
        show(message: message)
        return view
    }
    
    //MARK:模仿Android toast 弹出提示
    class func show(message:String) ->Void{
        let view = LGYToastView.defaultToastView
        let window = UIApplication.shared.windows.last
        window?.insertSubview(view, at: 1)
        view.backgroundColor = UIColor.init(red: 255/255.0, green: 132/255.0, blue: 0, alpha: 1)
        view.textAlignment = .center
        view.textColor = UIColor.white
        let font = UIFont.systemFont(ofSize: 15)
        view.font = font
        view.text = message
        let size = LGYTool.stringSize(string: message, font: font, maxSize: CGSize(width: UIScreen.main.bounds.size.width, height: 40))
        view.snp.makeConstraints { (make) in
            make.bottom.equalTo((window?.snp.bottom)!).offset(-64)
            make.width.greaterThanOrEqualTo(size.width+20)
            make.height.equalTo(40)
            make.centerX.equalTo((window!.snp.centerX))
        }
        view.LGyCornerRadius = 20
        view.layoutIfNeeded()
        view.alpha = 1
        view.addTimer(timeInterval: Double(view.timeInterval))
    }
    
    //MARK:定时器
    private func addTimer(timeInterval:Double) {
        timerShow?.invalidate()
        timerShow = nil
        timerShow = Timer(timeInterval: timeInterval, target: self, selector: #selector(cancle), userInfo: nil, repeats: true)
        RunLoop.current.add(timerShow!, forMode: .commonModes)

    }
    
    
   @objc func cancle() -> Void {
    weak var vc = self
        if isCanCancle {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
                
            }, completion: { (finish) in
                if finish {
                    vc?.callBlock?()
                    vc?.removeFromSuperview()
                }
            })
        }
    }

}
