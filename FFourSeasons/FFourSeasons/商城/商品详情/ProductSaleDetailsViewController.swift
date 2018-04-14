//
//  ProductSaleDetailsViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/26.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ProductSaleDetailsViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var goods_detailArray:Array<String>?
    var goods_detailImageHeight:[Int : CGFloat] = [:]
    var rightBarItem:UIBarButtonItem!
    var productInformation:Goods?
    var productModel:Model_api_goodsDetail?
    var productGuiGe:NSArray?
    static let lock = NSLock()
    var comment:Comment?
    
    @IBOutlet weak var commentMaginLC: NSLayoutConstraint!
    @IBOutlet weak var commentHeightLC: NSLayoutConstraint!
    @IBOutlet weak var headerScollerView: LCycleView!
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var payBackView: UIView!
    
  
    @IBOutlet weak var spelabel: UILabel!
    @IBOutlet weak var productDetailTableViewLC: NSLayoutConstraint!
    @IBOutlet weak var productDetailTableView: UITableView!
    @IBOutlet weak var productInformationView: UIView!
    @IBOutlet weak var productNameLabel: UILabel! //产品名称
    @IBOutlet weak var productPriceLabel: UILabel! //￥产品价格
    @IBOutlet weak var line2_2Label: UILabel! //赠送购物点
    @IBOutlet weak var line2_3Label: UILabel! //销售量
    @IBOutlet weak var line2_4Label: UILabel! //店铺地址
    @IBOutlet weak var line3_1Label: UILabel! //快递

    @IBOutlet weak var line4_1Label: UILabel! //配送范围
    @IBOutlet weak var selectSpecificationsView: UIView!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var commentDescribeLabel: UILabel!
    @IBOutlet weak var specificationsTextLabel: UILabel!
    
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productDetailImageView: UIImageView!
    var timer:Timer?
    
    var isCollection = 1 //1 表示未收藏，2表示已经收藏
    var selectSpec = 0 //选择的规格
    var selectCountText = "1"
    var selectSpecPrice = "0.00"
    let specView = Bundle.main.loadNibNamed("LGYSelectCollectionView", owner: nil, options: nil)?.first as! LGYSelectCollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        viewShadowColor()
       
        addCommentInformation()
        addViewTapGestureRecognizerAction()
        viewStyle()
        self.title = "产品详情"
         navigationItemBack(title: "    ")
//       self.edgesForExtendedLayout = .init(rawValue: 64)
        setBackgroundColor()

    }
    
    //MARK:设置
    func viewStyle() -> Void {
        var str = "选择收藏.png"
        if isCollection == 2{
            str = "已经收藏.png"
        }
//        rightBarItem = navigationBarAddRightItem(_imageName: str, target: self, action: #selector(rightBarAction))
    }
    
    //MARK:导航栏右边按钮响应事件
    @objc func rightBarAction() ->Void{
        if isCollection == 1 {
            isCollection = 2
            
        }else if isCollection == 2{
            isCollection = 1
        }
        var str = "选择收藏.png"
        if isCollection == 2{
            str = "已经收藏.png"
        }
        rightBarItem.image = UIImage(named: str)?.withRenderingMode(.alwaysOriginal)
        
    }
    
    //MARK:设置阴影
    func viewShadowColor() -> Void {
        LGYTool.viewLayerShadow(view: productDetailView)
        LGYTool.viewLayerShadow(view: selectSpecificationsView)
        LGYTool.viewLayerShadow(view: productInformationView)
        LGYTool.viewLayerShadow(view: commentView)
        LGYTool.viewLayerShadowShadowOffsetHeight(view: payBackView)
    }
    
    
    
    //MARK:添加点击事件设置
    func addViewTapGestureRecognizerAction() -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(specificationsViewAction))
        selectSpecificationsView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(commentViewAction))
        commentView.addGestureRecognizer(tap2)
    }
    
    //MARK:设置产品销售信息
    func addContentProductSaleInformaiton(product:Goods?,productId:Int) ->Void{
        productInformation = product
        if productInformation != nil{
            productNameLabel.text = productInformation?.title
            if productInformation?.goods_type == 0{
                productPriceLabel.text = String(format: "￥%@", (productInformation?.price)!)
            }else{
                productPriceLabel.text = String(format: "%@积分", (productInformation?.price)!)
            }
            if  productInformation?.sale == nil{
                productInformation?.sale = 0
            }
            line2_3Label.text = String(format: "累计销售%D笔", (productInformation?.sale)!)
            line2_4Label.text = String(format: "%@", (productInformation?.origin_place)!)
            line4_1Label.text = String(format: "配送范围：%@", (productInformation?.delivery_address)!)
            line3_1Label.text = "· 快递：免运费    ·7天无理由退款    ·48小时内发货"
            line2_2Label.text = ""
            if productInformation?.main_imgs != nil{
                let array = productInformation?.main_imgs.split(separator: ";").map(String.init)
                if array != nil && array!.count > 0 {
                    setHeaderView(array: array!)
                }
            }
            if productInformation?.goods_detail != nil {
                goods_detailArray = productInformation?.goods_detail.split(separator: ";").map(String.init)
                setDetails()
            }
        }
        
        if productId > 0{
            loadDataScoure(productId:productId)
        }
        
    }
    
    //MARK:设置图片详情
    func setDetails() -> Void {
        if (goods_detailArray?.count)! > 0{
            productDetailTableViewLC.constant = 100
        }
        productDetailTableView.rowHeight = 100
        productDetailTableView.bounces = false
        productDetailTableView.delegate = self
        productDetailTableView.dataSource = self
        productDetailTableView.separatorColor = UIColor.clear
        productDetailTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goods_detailArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        addImageUrl(imageUrl: goods_detailArray![indexPath.row], cell: cell,indexPath: indexPath)
       
        return cell;
    }
    
    //MARK:设置图片详情cell图片
    func addImageUrl(imageUrl:String,cell:UITableViewCell,indexPath:IndexPath) -> Void {
        var imgView = cell.viewWithTag(1000) as? UIImageView
        if imgView == nil{
            imgView = UIImageView()
            imgView?.tag = 1000
            cell.addSubview(imgView!)
            //设置collectionView和pageControl的约束
            imgView?.snp.makeConstraints { (make) in
                make.top.equalTo(cell.snp.top)
                make.left.equalTo(cell.snp.left)
                make.bottom.equalTo(cell.snp.bottom)
                make.right.equalTo(cell.snp.right)
            }
        }
        weak var vc = self
        if imageUrl.contains("http") {
            imgView?.setImageWith(URLRequest.init(url: URL.init(string: imageUrl)!), placeholderImage: UIImage.init(named: "loading.png")!, success: { (request, response, image) in
                imgView?.image = image
                if vc?.goods_detailImageHeight[indexPath.row] == nil {
                    let scale = image.size.width/image.size.height
                    let height = cell.frame.size.width/scale
                    vc?.goods_detailImageHeight[indexPath.row] = height
                    vc?.productDetailTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
                    vc?.addTimer()
                }
            }, failure: { (request, response, error) in
                
            })
        }else{
            imgView?.image = UIImage.init(named: imageUrl)
        }
        
        
    }
    
    //MARK:定时器
    private func addTimer() {
        timer?.invalidate()
        timer = Timer(timeInterval: 0.01, target: self, selector: #selector(showTableView), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc func showTableView()->Void{
        productDetailTableViewLC.constant = productDetailTableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let s = goods_detailImageHeight[indexPath.row]{
            return s
        }
        return 1
    }
    
    //MARK:设置头部滚动
    func setHeaderView(array:Array<String>) -> Void {
        headerScollerView.setup(array: array as NSArray)
        headerScollerView.pageColor(defaultColor: UIColor.init(red: 187/255.0, green: 187/255.0, blue: 187/255.0, alpha: 1), selectColor: UIColor.white)
        headerScollerView.pageControlBackView.backgroundColor = UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        backScrollView.delegate = self
    }
    
    //MARK:加载数据
    func loadDataScoure(productId:Int) -> Void {
        weak var vc = self;
        //MARK:加载产品分类信息
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_goodsDetail
        , parameters: ["gId":String.init(format: "%D", productId),"token":Model_user_information.getToken()], progress: nil) { (object,isError) in
            if isError{
                return
            }
           vc?.setDataScoure(object: object)
        }
        loadComment(gId:"\(productId)",pageNumber:"1")
    }
    
    func setDataScoure(object:Any?) -> Void {
        productModel = Model_api_goodsDetail.yy_model(withJSON: object)
        if let good = productModel?.goods{
            productInformation = good
             addContentProductSaleInformaiton(product:productModel?.goods,productId: 0)
        }
    }
    
   
    
    //MARK:给label添加左边的圆点
    func viewAddLeftPoint(label:UILabel,isHidden:Bool) -> Void {
   
        var pointView = view.viewWithTag(2000)
        if isHidden {
            pointView?.isHidden = true
            return
        }
        if pointView == nil {
            let width = CGFloat(2)
            let maginTop = (label.frame.size.height - width)/2
            pointView = UIView(frame: CGRect(x: -5, y: maginTop, width: width, height: width))
            label.addSubview(pointView!)
            pointView?.backgroundColor = label.textColor
        }
        pointView?.isHidden = false
        
    }
    
    //MARK:设置评论内容
    func addCommentInformation() -> Void {
        commentImageView.imageFromURL("http://img1.360buyimg.com/n6/jfs/t8368/109/929691645/455254/ebb7a902/59b10b85N9795cd8f.jpg", placeholder: UIImage.init(named: "loading.png")!)
        commentNameLabel.text = "七夕e分手"
        commentDescribeLabel.text = "有道翻译提供即时免费的中文、英语、日语、韩语、法语、俄语、西班牙语、葡萄牙语、越南语全文翻译、网页翻译、文档翻译服务。"
        specificationsTextLabel.text = "规格：黑色       数量：1株"
    }
    
    //MARK:选择规格点击响应
    @objc func specificationsViewAction() -> Void {
        specView.frame = UIScreen.main.bounds
        weak var vc = self;
        specView.callBlock = {(text,array) ->Void in
            vc?.selectSpec = 0
            vc?.selectCountText = text
            if vc?.productInformation?.goods_type == 0{
                vc?.productPriceLabel.text = String(format: "￥%@", (vc?.productInformation?.price)!)
            }else{
                vc?.productPriceLabel.text = String(format: "%@积分", (vc?.productInformation?.price)!)
            }
            vc?.specificationDeal(text: text, array: array!)
            vc?.specView.removeFromSuperview()
        }
        let array = NSArray.yy_modelArray(with: Spec_json.classForCoder(), json: productInformation?.spec_json)
        specView.collectionViewStyle(array:array as? Array<Spec_json>)
        UIApplication.shared.keyWindow?.addSubview(specView)
    }
    
    //MARK:获取规格ID
    func specificationDeal(text:String,array:Array<String>) -> Void {
        var spec = ""
        if productModel != nil{
            productGuiGe = self.productModel?.itemList! as NSArray?
            if productGuiGe != nil{
                for index in productGuiGe! { //获取规格组
                    let item = index as? ItemList
                    let listSpec = item?.spec
                    var str = ""
                    if listSpec != nil{  //遍历规格每一个小组成员
                        for s in listSpec!{
                            let spec = s as Spec?
                            if spec != nil{
                                if str.count > 0{
                                    str += ","
                                }
                                str += (spec?.name)! //拼接规格组合为字符串
                            }
                        }
                    }
                   
                    var flag = true
                    for guige in array{ //遍历是否是否为选择规格
                        if !str.contains(guige){
                            flag = false
                            break
                        }
                    }
                    if flag{
                        spec = str
                        selectSpec = (item?._id)!
                        if productInformation?.goods_type == 0{
                            productPriceLabel.text = "￥\((item?.price)!)"
                        }else{
                            productPriceLabel.text = "\((item?.price)!)积分"
                        }
                    }
                    
                }
            }
            spelabel.text = "已选规格：\(spec)，数量\(text)"
        }
    }
    
    @IBAction func allCommentsAction(_ sender: Any) {
        let vc = Bundle.main.loadNibNamed("AllCommentsViewController", owner: nil, options: nil)?.first as! AllCommentsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK:买家评论点击响应
    @objc func commentViewAction() -> Void {
        let vc = Bundle.main.loadNibNamed("AllCommentsViewController", owner: nil, options: nil)?.first as! AllCommentsViewController
        vc.gId = productInformation!._id
        vc.loadComment(gId: String.init(format: "%D", (productInformation?._id)!), pageNumber: "1")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK:购物车
    @IBAction func shoppingCarAction(_ sender: Any) {
        if selectSpec == 0 {
//            specificationsViewAction()
            LGYToastView.show(message: "请选择规格")
        }else{
            if productInformation == nil || selectCountText.count < 0{
                return
            }
            LGYAFNetworking.lgyPost(urlString: APIAddress.api_addCart, parameters: ["itemId":String.init(format: "%D", selectSpec),"token":Model_user_information.getToken(),"count":selectCountText], progress: nil, responseBlock: { (object, isError) in
                if !isError {
                    let model = Model_user_information.yy_model(withJSON: object)
                    if model == nil{
                        return
                    }
                    LGYToastView.show(message: (model?.msg)!)
                }
            })
        }
    }
    
    //MARK:立即购买
    @IBAction func purchaseAction(_ sender: Any) {
        if selectSpec == 0 {
            LGYToastView.show(message: "请选择规格")
            return
        }
        let vc = PurchaseImmediatelyViewController()
        var item = CartList()
        item.price = productInformation!.price
        item.item_url = productInformation?.small_icon
        item.count = Int(selectCountText)!
        item.name = productInformation?.title
        item.goods_type = (productInformation?.goods_type)!
        vc.dataScoure = [item]
        vc.loadAddOrder(orderStr: String.init(format: "%D:%@", selectSpec,selectCountText))
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSLog("%lf", scrollView.contentOffset.y)
        if scrollView.contentOffset.y <= 150.0 && scrollView.contentOffset.y >= -64{
            let alpha = (scrollView.contentOffset.y+64)/150.0
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(red: 255/255.0, green: 255/255.0, blue:255/255.0, alpha: alpha)), for: .default)
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//    self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)), for: .default)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.0)), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        //要下面两句才能使scrollview展示正确
        backScrollView.setContentOffset(CGPoint.init(x: 0, y: -64), animated: true)
        self.view.layoutIfNeeded()
//         self.navigationItem.rightBarButtonItems = [rightBarItem]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let bgImage = UIImage(named: "导航矩形3x.png")?.resizableImage(withCapInsets:  UIEdgeInsets(), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(bgImage, for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//         self.navigationItem.rightBarButtonItems = nil
    }
    
    //MARK:加载评论
    func loadComment(gId:String,pageNumber:String){
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_commentList, parameters: ["gId":gId,"pageNumber":pageNumber,"token":Model_user_information.getToken()], progress: nil) {[weak self] (object, isError) in
            if let weakSelf = self{
                if !isError {
                    let model = Model_api_comment.yy_model(withJSON: object as Any)
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        if let array = model?.page.list{
                            if array.count > 0{
                                weakSelf.comment = array[0]
                            }
                        }
                    }else if let msg = model?.msg{
                        LGYToastView.show(message: msg)
                    }
                }
                weakSelf.setComment()
            }
        }
    }
    
    func setComment()->Void{
        if comment != nil{
            commentView.isHidden = false
            commentNameLabel.text = comment?.nick_name
            if let url = comment?.head_url{
                commentImageView.imageFromURL(url, placeholder: UIImage(named: "loading.png")!)
            }else{
                commentImageView.image =  UIImage(named:"loading.png")
            }
            commentDescribeLabel.text = comment?.content
            specificationsTextLabel.text = comment?.created_time
            commentHeightLC.constant = 117
            commentMaginLC.constant = 16
        }else{
            commentNameLabel.text = nil
            commentImageView.image =  nil
            commentDescribeLabel.text = nil
            specificationsTextLabel.text = nil
            commentView.isHidden = true
            commentHeightLC.constant = 0
            commentMaginLC.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


