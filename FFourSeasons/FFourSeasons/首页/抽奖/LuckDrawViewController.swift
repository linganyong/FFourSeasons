//
//  LuckDrawViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class LuckDrawViewController: UIViewController {

    @IBOutlet weak var luckDrawView: LuckDrawView!
    @IBOutlet weak var luckDrawButton: UIButton!
    let dataScoure = ["鸡蛋","鱼","手机","笔记本","谢谢参与","积分100","一等奖","二等奖","三等奖"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "幸运大转盘"
        luckDrawSetUp()
        self.view.layoutIfNeeded()
        luckDrawButton.LGyCornerRadius = Float(luckDrawButton.frame.size.width/2)
        setBackgroundColor()
        navigationItemBack(title: nil)
    }

    
    func luckDrawSetUp() -> Void {
        luckDrawView.backgroundColor = UIColor.clear
        luckDrawView.drawArray(drawName:dataScoure )
    }
    
    @IBAction func startLuckDrawAction(_ sender: Any) {
        let arc4 = Int(arc4random()) % dataScoure.count
        weak var vc = self
        luckDrawButton.isEnabled = false
        luckDrawView.startLuckDrawAnimationValue(value: Float(arc4)) { (anima, finish) in
            vc?.alertView(_title: "恭喜您中奖了！", _message: NSString.init(format: "恭喜您获得【%@】!",self.dataScoure[arc4]) as String, _bText: "确定")
            vc?.luckDrawButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type: .White)
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
