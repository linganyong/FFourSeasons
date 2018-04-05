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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部评论"
        setTableView()
        setBackgroundColor()
        navigationItemBack(title: "")
        addEmptyView(frame: nil)
    }
    
    func  setTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "AllCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "AllCommentsTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllCommentsTableViewCell", for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
    
     func loadComment(gId:String,pageNumber:String){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_commentList, parameters: ["gId":gId,"pageNumber":pageNumber,"token":Model_user_information.getToken()], progress: nil) { (object, isError) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
