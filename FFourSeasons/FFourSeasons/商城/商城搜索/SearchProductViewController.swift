//
//  SearchProductViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/10.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class SearchProductViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let searchView = UIView()
    public let searchTextField = UITextField()
    var rightBarButton:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        navigationItemBack(title: nil)
        rightBarButton = navigationBarAddRightItem(_imageName: "搜索.png", target: self, action: #selector(searchAction))
        navigationBarAddSearchTextField()
        setBackgroundColor()
    }
    
    //MARK:导航栏添加搜索
    func navigationBarAddSearchTextField() -> Void {
        searchView.frame =  CGRect(x:80, y: 9, width: self.view.frame.size.width - 80*2, height: 26)
        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.left.equalTo(searchView.snp.left).offset(8)
            make.width.equalTo(searchView.snp.width).offset(-16)
            make.top.equalTo(searchView.snp.top).offset(2)
            make.height.equalTo(searchView.snp.height).offset(-4)
        }
        searchTextField.delegate = self
        searchTextField.backgroundColor = UIColor.clear
        searchTextField.placeholder = "输入查询"
      
        searchTextField.font = UIFont.systemFont(ofSize: 12)
        searchView.tag = 1000
        searchView.layer.cornerRadius = searchView.frame.size.height/2;
        searchView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        searchView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        searchView.layer.borderWidth = 0.5
        searchView.addSubview(searchTextField)
    }
    
   
    func setSearchText(text:String?) -> Void {
        searchTextField.text = text
        tableView.lgyPageIndex = 1
        loadProduct(text: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func searchAction() ->Void{
            tableView.lgyPageIndex = 1
         loadProduct(text:searchTextField.text )
    }
    
    func setTableView() -> Void {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = self.view.frame.size.width/4
        tableView.separatorColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.lgyDataScoure = Array<Goods>()
        tableView.register(UINib.init(nibName: "SearchProductTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchProductTableViewCell")
        weak var tb = tableView
        weak var vc = self
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            tb?.lgyPageIndex = 1+(tb?.lgyPageIndex)!
            vc?.loadProduct(text: vc?.searchTextField.text)
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SearchProductTableViewCell
        let na = Bundle.main.loadNibNamed("ProductSaleDetailsViewController", owner: nil, options: nil)![0] as! ProductSaleDetailsViewController
        na.addContentProductSaleInformaiton(product:cell.model!, productId: (cell.model?._id)!)
        self.navigationController?.pushViewController(na, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.lgyDataScoure!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchProductTableViewCell", for: indexPath) as! SearchProductTableViewCell
        cell.selectionStyle = .none
        let goods = tableView.lgyDataScoure[indexPath.row] as! Goods
         cell.model = goods
        cell.setDataScoure(imageUrl: goods.small_icon, line1Str: goods.title, line2Str: String.init(format: "￥%@", goods.price))
        return cell
    }

    
    //MARK:获取产品数据
    func loadProduct(text:String?) -> Void {
        weak var tb = tableView ;
        var search = text
        if search == nil{
            search = ""
        }
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_searchGoods, parameters: ["pageNumber":String(format: "%D", (tableView?.lgyPageIndex)!),"key":search!,"token":Model_user_information.getToken()], progress: nil,cacheName:nil) { (object,isError) in
            if !isError{
                let model = Model_api_searchGoods.yy_model(withJSON: object as Any)
                if let list = model?.goodsList.list {
                    if tb?.lgyPageIndex == 1{
                        tb?.lgyDataScoure.removeAll();
                    }
                    for item in list {
                        tb?.lgyDataScoure.append(item)
                    }
                    tb?.reloadData();
                }
            }
            
            tb?.mj_header?.endRefreshing()
            tb?.mj_footer?.endRefreshing()
         
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(searchView)
        setNavigationBarStyle(type:.White)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchView.removeFromSuperview()
       setNavigationBarStyle(type:.Default)
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
