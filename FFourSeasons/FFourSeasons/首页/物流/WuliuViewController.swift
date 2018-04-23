//
//  WuliuViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/22.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class WuliuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var deslabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    var dataScoure = Array<[AnyHashable: Any]>()
    var number:String? //物流单号
    var headerImageUrl:String? //头像
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 247/255.0, green: 248/255.0, blue: 249/255.0, alpha: 1)
        self.title = "物流信息"
        navigationItemBack(title: "    ")
        setTableView()
        addEmptyView(frame: nil)
    }
    
    

    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "WuliuTableViewCell", bundle: nil), forCellReuseIdentifier: "WuliuTableViewCell")
        if let code = number{
            loadQuery(number: code)
        }
        if let url = headerImageUrl{
            headerImageView.imageFromURL(url, placeholder: UIImage(named: "loading.png")!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataScoure.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WuliuTableViewCell", for: indexPath) as! WuliuTableViewCell
        cell.selectionStyle = .none
        let dic = dataScoure[indexPath.row]
        if indexPath.row != 0{
            cell.showImageView.image = UIImage(named:"物流")
        }else{
            cell.showImageView.image = UIImage(named:"物流最新")
        }
        if let date = dic["time"] as? String{
            cell.dateLabel.text = date
            cell.dateLabel.changeRange(range: NSRange.init(location: 10, length: date.count - 10), color: nil, textSize: 12)
        }
        if let msg = dic["status"] as? String{
            cell.detailLabel.text = msg
            cell.detailLabel.setlineSpace(lineSpace: 4)
        }
        
        
        
        return cell
        
    }
    
    //MARK:加载数据
    func loadQuery(number:String) ->Void {
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_query, parameters: ["number":number
            ,"token":Model_user_information.getToken()], progress: nil) { [weak self](object, isError) in
                if !isError {
                    let model = Model_user_information.yy_model(withJSON: object as Any)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        self?.setData(object: object as! [AnyHashable : Any])
                    }
                }
        }
    }
    
    
    func setData(object:[AnyHashable: Any]){
        var name = ""
        if let express = object["express"] as? [AnyHashable: Any]{
            if let ss = express["name"] as? String{
                name = ss
                removeEmptyView()
            }
        }
        if let dic = object["result"] as? [AnyHashable: Any] {
            if let result = dic["result"] as? [AnyHashable: Any]{
                if let list = result["list"] as? Array<[AnyHashable: Any]>{
                    dataScoure = list;
                    tableView.reloadData()
                }
                if let _number = result["number"] as? String{
                    deslabel.text = "\(name)-\(_number)"
                }
            }
            if let status = dic["status"] as? String {
                if status == "0" {
                    titlelabel.text = "已签收"
                }else{
                    titlelabel.text = "派送中"
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNavigationBarStyle(type:.White)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarStyle(type:.White)
        
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
