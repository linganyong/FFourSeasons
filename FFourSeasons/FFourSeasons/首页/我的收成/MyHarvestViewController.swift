//
//  MyHarvestViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class MyHarvestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let pageView = LGYPageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPageView()
        self.view.backgroundColor = UIColor.init(red: 247/255.0, green: 248/255.0, blue: 249/255.0, alpha: 1)
        self.title = "我的收成"
        navigationItemBack(title: "    ")
        setBackgroundColor()
    }
    
    func setPageView() -> Void {
        pageView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64)
        self.view .addSubview(pageView)
        
        pageView.addContent(titleArray: ["全部","配送完成","配送中","未配送","作废","自提"], height: 30, isHiddenHeader: false)
        pageView.headerBtnStyle(defaultTextColor: UIColor.init(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1), selectTextColor: UIColor.init(red: 79/255.0, green: 210/255.0, blue: 60/255.0, alpha: 1), headerBtnWidth: self.view.frame.size.width/6, headerLineHeight: 1,textFront: 12)
        for i in 0...5{
            let tb = pageView.pageViewtableView(index: i)
            tb?.delegate = self
            tb?.rowHeight = self.view.frame.size.width/4+16
            tb?.dataSource = self
            tb?.backgroundColor = UIColor.clear
            tb?.separatorColor = UIColor.clear
            tb?.showsVerticalScrollIndicator = false
            tb?.register(UINib.init(nibName: "MyHarvestTableViewCell", bundle: nil), forCellReuseIdentifier: "MyHarvestTableViewCell")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO:dataScoure.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyHarvestTableViewCell", for: indexPath) as! MyHarvestTableViewCell
        cell.selectionStyle = .none
        cell.maginLeftLayoutConstraint.constant = self.view.frame.size.width/12-8
        cell.maginTopLayoutConstraint.constant = self.view.frame.size.width/12
        cell.maginBottomLayoutConstraint.constant = 8
        cell.setDataScoure(imageUrl: "https://img13.360buyimg.com/n1/s160x160_jfs/t16288/180/1610373802/424365/94d94a/5a5708bfN8e93b650.jpg", line1Str: "车厘子", line2Str: "配送中", line3Str: String.init(format: "x%d", 200))
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
