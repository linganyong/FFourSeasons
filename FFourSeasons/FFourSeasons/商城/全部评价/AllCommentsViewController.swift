//
//  AllCommentsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/7.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class AllCommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var commentList = Array<Comment>()
    var gId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部评论"
        setTableView()
        setBackgroundColor()
        navigationItemBack(title: "")
       
    }
    
    func  setTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
        weak var tb = tableView
        weak var vc = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            if vc != nil{
                tb!.lgyPageIndex = 1
                vc!.loadComment(gId: "\(vc!.gId)", pageNumber: "\((tb!.lgyPageIndex)!)")
            }
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            if vc != nil{
            tb!.lgyPageIndex = 1+(tb!.lgyPageIndex)!
            vc!.loadComment(gId: "\(vc!.gId)", pageNumber: "\((tb!.lgyPageIndex)!)")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
//        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let com = commentList[indexPath.row]
        var height = CGFloat(120)
        if let str = com.content{
            let size = LGYTool.textSize(text: str, font: UIFont.systemFont(ofSize: 8), maxSize: CGSize(width:tableView.frame.width - 64 , height: 1000))
            height = size.height + 110
        }
        return height;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath) as! AllCommentsTableViewCell
        cell.selectionStyle = .none
        cell.setModel(item: commentList[indexPath.row])
        return cell
    }
    
     func loadComment(gId:String,pageNumber:String){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_commentList, parameters: ["gId":gId,"pageNumber":pageNumber,"token":Model_user_information.getToken()], progress: nil) {[weak self] (object, isError) in
            if !isError {
                if let weakSelf = self{
                    let model = Model_api_comment.yy_model(withJSON: object as Any)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        if let array = model?.page.list{
                            for item in array{
                                weakSelf.commentList.append(item)
                            }
                            weakSelf.tableView.reloadData()
                        }
                    }else if let msg = model?.msg{
                        LGYToastView.show(message: msg)
                    }
                }
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
