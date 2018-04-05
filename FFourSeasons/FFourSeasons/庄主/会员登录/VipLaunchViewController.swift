//
//  VipLaunchViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class VipLaunchViewController: UIViewController {

    @IBOutlet weak var passworkBackView: UIView!
    @IBOutlet weak var userNameBackView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//          self.title = ""
            setViewStyle()
        setBackgroundColor()
    }
    
    func setViewStyle() -> Void {
        launchButton.layer.borderColor = UIColor.init(red: 0.0, green: 200/255.0, blue: 134/255.0, alpha: 1).cgColor
        launchButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.init(red: 217/255.0, green: 177/255.0, blue: 51/255.0, alpha: 1).cgColor
        registerButton.layer.borderWidth = 1
        
        passworkBackView.layer.borderColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1).cgColor
        passworkBackView.layer.borderWidth = 1
        userNameBackView.layer.borderColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1).cgColor
        userNameBackView.layer.borderWidth = 1
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
