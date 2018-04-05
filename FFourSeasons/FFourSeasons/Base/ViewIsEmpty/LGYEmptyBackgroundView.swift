//
//  LGYEmptyBackgroundView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/20.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LGYEmptyBackgroundView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    
    class func loadViewFromNib(message:String?) ->LGYEmptyBackgroundView{
        let view = Bundle.main.loadNibNamed("LGYEmptyBackgroundView", owner: nil, options: nil)?.first as! LGYEmptyBackgroundView
        view.messageLabel.text = message
        return view
    }
    
    func addToSuperview(view:UIView,frame:CGRect?,dataScoureCount:Int) -> Void {
        if dataScoureCount > 0{
            self.removeFromSuperview()
        }else{
            if frame == nil {
                self.frame = view.bounds
            }else{
                self.frame = frame!
            }
            view.addSubview(self)
        }
        
    }
    
//    func addToSuperview(tableView:UITableView,frame:CGRect?,dataScoureCount:Int) -> Void {
//        tableView .addObserver(self, forKeyPath: "", options: .new, context: nil)
//        
//    }
//    
//    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
//        
//    }
//    
//    deinit {
//        self.removeObserver("", forKeyPath: "")
//    }
    
}
