//
//  LGYLineSelectView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias LGYLineSelectViewCallBlock = (_ keyStr:String,_ position:Int) ->Void

class LGYLineSelectView: UIView,UITableViewDataSource,UITableViewDelegate {
    var dataScoure:NSArray?
    static let defaultLineSelectView = LGYLineSelectView()
    let backView = UIView()
    let tableView = UITableView()
    private var callBlock:LGYLineSelectViewCallBlock?
    
    class func show(array:NSArray?,block:LGYLineSelectViewCallBlock?) ->Void{
        if array == nil{
            defaultLineSelectView.dataScoure = NSArray()
        }
        defaultLineSelectView.dataScoure = array!
        defaultLineSelectView.initData()
        defaultLineSelectView.callBlock = block
    }
    
    func initData() ->Void{
        self.frame = UIScreen.main.bounds
        UIApplication.shared.keyWindow?.addSubview(self)
        self.setBackView()
        self.setTitleTableView()
        
    }
    
    func setBackView(){
        self.backView.frame = UIScreen.main.bounds
        self.backView.backgroundColor = UIColor.black
        self.backView.alpha = 0.3
        self.addSubview(backView)
        let tap =  UITapGestureRecognizer.init(target: self, action: #selector(backViewTapAction))
        self.backView.addGestureRecognizer(tap)
    }
    
    @objc func backViewTapAction() ->Void{
        self.removeFromSuperview()
    }
    
    func setTitleTableView() -> Void {
        let width = UIScreen.main.bounds.size.width - 64
        let rowHeight = CGFloat(44.0)
        let heith = rowHeight*CGFloat((dataScoure?.count)!)
        let maginTop = (UIScreen.main.bounds.size.height - heith)/2.0
        tableView.frame = CGRect(x: 32, y: maginTop, width: width, height: heith)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "LGYLineSelectViewTableViewCell", bundle: nil), forCellReuseIdentifier: "LGYLineSelectViewTableViewCell")
        self.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.LGyCornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LGYLineSelectViewTableViewCell", for: indexPath) as! LGYLineSelectViewTableViewCell
        cell.LGYTitleLabel?.text = dataScoure![indexPath.row] as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callBlock?(dataScoure![indexPath.row] as! String,indexPath.row)
        self.removeFromSuperview()
    }
   

}
