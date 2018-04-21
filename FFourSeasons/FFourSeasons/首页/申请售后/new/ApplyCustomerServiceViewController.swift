//
//  ApplyCustomerServiceViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/12.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class ApplyCustomerServiceViewController: UIViewController,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,LGYImageSelectViewControllerDelegate,ApplyCustomerServiceImageCollectionViewCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var describleTextView: UITextView!
    @IBOutlet weak var describleLabel: UILabel!
    @IBOutlet weak var descibleBackView: UIView!
    
    var rightBarItem:UIBarButtonItem!
    var orderDetail:OrderList?
    var imageArray = Array<UIImage>()
    var imageUrlArray = Array<String>()
    var cellWidth = CGFloat(0.0)
    var selectIndexPaht:IndexPath?
    var isTextEdit = false //是否在编辑文本，用于取消点击冲突
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请售后"
        navigationItemBack(title: "    ")
        rightBarItem = navigationBarAddRightItem(_imageName: "黑色确定", target: self, action: #selector(rightBarAction))
        setTextView()
        setCollectionView()
    }
    
    func setCollectionView()->Void{
        self.view.layoutIfNeeded()
        let layout = UICollectionViewFlowLayout()
        cellWidth = CGFloat((collectionView.frame.size.width - 41)/3)
        layout.itemSize = CGSize(width: cellWidth, height:cellWidth)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ApplyCustomerServiceImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ApplyCustomerServiceImageCollectionViewCell")
        addImageArray(iamge: UIImage(named:"图片.png")!,imageUrl:nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func addImageArray(iamge:UIImage,imageUrl:String?)->Void{
        if (selectIndexPaht == nil || selectIndexPaht?.row == 0){
            imageArray.append(iamge)
            if imageUrl != nil{
                imageUrlArray.append(imageUrl!)
            }
//        }else{
//            imageArray[selectIndexPaht!.row] = iamge
//            imageUrlArray[selectIndexPaht!.row] = imageUrl
        }
       
        collectionViewHeightLC.constant = cellWidth*2+20
        collectionView.layoutIfNeeded()
        
        collectionView.reloadData()
        
    }
    
    func deleteImageArray(indexPath:IndexPath)->Void{
        
        imageArray.remove(at: indexPath.row)
        imageUrlArray.remove(at: indexPath.row-1)
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplyCustomerServiceImageCollectionViewCell", for: indexPath) as! ApplyCustomerServiceImageCollectionViewCell
        cell.myImageView.image = imageArray[indexPath.row]
        cell.deleteButton.isHidden = true
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndexPaht = indexPath
        switch indexPath.row {
        case 0:
            if imageArray.count == 6{
                LGYToastView.show(message: "最多只能添加5张图片")
                return
            }
            //判断设置是否支持图片库
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let vc = Bundle.main.loadNibNamed("LGYImageSelectViewController", owner: nil, options: nil)?.first as! LGYImageSelectViewController
                vc.delegate = self
                vc.isNeedCut = false
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                alertView(_title: "您还没有开启相册权限", _message: "请您到：设置 > 人人庄园 中添加相册权限", _bText: "确定")
            }
            break
        default:
            let cell = collectionView.cellForItem(at: indexPath) as! ApplyCustomerServiceImageCollectionViewCell
            cell.deleteButton.isHidden = false
            cell.indexPath = indexPath
            cell.delegate = self
            break
        }
    }
    
    func applyCustomerServiceImageCollectionViewCell(cell: ApplyCustomerServiceImageCollectionViewCell) {
        deleteImageArray(indexPath:cell.indexPath!)
    }
    
    //MARK:修改头像代理图片回调
    func lgyImageSelectViewController(viewController: LGYImageSelectViewController, image: UIImage, imagePath: String) {
        viewController.navigationController?.popViewController(animated: true)
        LGYAFNetworking.lgyPushImage(urlString: APIAddress.api_upload, parameters: nil,array: [image], progress: nil) { [weak self](url, isError) in
            if !isError || url == nil || !(url?.contains("http"))!{
                if let weakSelf = self{
                    weakSelf.addImageArray(iamge: image, imageUrl: url)
                }
                return
            }
            
        }
    }
    
    func setTextView() -> Void {
        LGYTool.viewLayerShadow(view: descibleBackView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(registerKeyBoard))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        describleTextView.delegate = self
    }
    
    @objc func registerKeyBoard() ->Void{
        describleTextView.resignFirstResponder()
        if describleTextView.text == nil || describleTextView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
        
    }
    
    // MARK:UIGestureRecognizerDelegate pro --点击手势代理，为了去除手势冲突--
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isTextEdit
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        describleLabel.text = ""
        isTextEdit = true
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == nil || textView.text.count == 0{
            describleLabel.text = " 请输入退货原因"
        }
        isTextEdit = false
        return true
    }
    
    //MARK:导航栏右边按钮响应
    @objc func rightBarAction() -> Void {
        if describleTextView.text == nil || describleTextView.text.count == 0{
            LGYToastView.show(message: "请输入退货原因")
            return
        }
        loadCustomerService()
    }
    
    //MARK:提交售后申请
    func loadCustomerService(){
        var imgs = ""
        for intem in imageUrlArray{
            if imgs.count == 0 {
                imgs = "\(intem)"
            }else{
                imgs = ";\(intem)"
            }
        }
        LGYAFNetworking.lgyPost(urlString: APIAddress.api_customerService, parameters: ["token":Model_user_information.getToken()
            ,"oId":"\(orderDetail!._id)"
            ,"content":describleTextView.text!
            ,"imgs":imgs], progress: nil, cacheName: nil) { [weak self](object, isError) in
                if !isError {
                    let model = Model_user_information.yy_model(withJSON: object as Any)
                    if let msg = model?.msg{
                        LGYToastView.show(message: msg)
                    }
                    if LGYAFNetworking.isNetWorkSuccess(str: model?.code){
                        if let weakSelf = self{
                            weakSelf.applyCustomerServiceSuccess()
                        }
                    }
                }
        }
    }
    
    func applyCustomerServiceSuccess()->Void{
        let vc = Bundle.main.loadNibNamed("CustomerServiceApplyResultViewController", owner: nil, options: nil)?.first as! OrderDetailsViewController
        vc.orderDetail = orderDetail
        vc.setText()
        vc.loadOrderDetails()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        setNavigationBarStyle(type: .White)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItems = [rightBarItem]
        setNavigationBarStyle(type: .White)
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
