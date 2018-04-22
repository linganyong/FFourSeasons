//
//  EvaluateViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class EvaluateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var rightBarItem:UIBarButtonItem!
   var productLsit = Array<OrderDetails>()
   
    @IBOutlet weak var tableView: UITableView!
    var gId:String! = ""
    var oId:String! = ""
    var dId:String! = ""
    var count:Int = 0
    let lock = NSLock()
    var sendList = Array<Int>()
    var isSend = false
    var allCount  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "白色确定", target: self, action: #selector(rightBarAction))
        setBackgroundColor()
    }

    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if isSend{
            LGYToastView.show(message: "已经在传评价，请稍等！")
            return
        }
        allCount = productLsit.count
        count = 0
        sendList.removeAll()
        var flag = true
        //一条条商品上传
        for i in 0..<productLsit.count{
            if let cell = tableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? EvaluateTableViewCell{
                if let gid = cell.model?.g_id,let text = cell.desTextView.text {
                    if text.count > 0{
                        flag = false
                        isSend = true
                        loadComment(gId:gid, oId: oId, dId: "0", ccontent: text)
                    }
                }
               
            }
        }
        if flag{
            LGYToastView.show(message: "请输入您的评价！")
        }
        
    }
    
    
    
    //MARK:给每个商品上传评价
    func loadComment(gId:Int,oId:String,dId:String,ccontent:String){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_comment, parameters: ["gId":"\(gId)"
            ,"oId":oId
            ,"dId":dId
            ,"content":ccontent
            ,"token":Model_user_information.getToken()], progress: nil) {[weak self] (object, isError) in
                if let weakSelf = self{
                    weakSelf.doCount(isError:isError,object: object!,gId: gId)
                }
        }
    }
    
    //MARK:统计上传
    func doCount(isError:Bool, object:Any?,gId:Int)->Void{
        lock.lock()
         count += 1
        if !isError && object != nil{
            let model = Model_api_comment.yy_model(withJSON: object!)
            if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                var index = 0
                for item in productLsit{
                    if item.g_id == gId{
                        productLsit.remove(at: index)
                        tableView.reloadData()
                        break
                    }
                    index += 1;
                }
            }
        }
        lock.unlock()
        //判断最后一条数据上传完成
        if count == allCount{
            isSend = false
            if productLsit.count == 0{
                navigationController?.popViewController(animated: true)
                LGYToastView.show(message: "评价成功")
            }else{
                LGYToastView.show(message: "评价失败")
            }
            
        }
    }
    
    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "EvaluateTableViewCell", bundle: nil), forCellReuseIdentifier: "EvaluateTableViewCell")
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productLsit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateTableViewCell", for: indexPath) as! EvaluateTableViewCell
        cell.selectionStyle = .none
        cell.setModel(item: productLsit[indexPath.row])
        return cell
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItems = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
