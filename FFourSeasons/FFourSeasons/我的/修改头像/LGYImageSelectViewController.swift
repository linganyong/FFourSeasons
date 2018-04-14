//
//  LGYImageSelectViewController.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit
import Photos
import _SwiftUIKitOverlayShims
import Foundation

protocol LGYImageSelectViewControllerDelegate : NSObjectProtocol {
    func lgyImageSelectViewController(viewController: LGYImageSelectViewController, image:UIImage,imagePath:String)
}

class LGYImageSelectViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ClipViewControllerDelegate {
    var dataScoure = NSMutableArray()
    var dataScoureMenu = Array<NSDictionary>()
    var selectMenuIndex = 0 //选择第几种图片类型的菜单位置
    weak var delegate:LGYImageSelectViewControllerDelegate?
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewHeightLC: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var isNeedCut = true //是否需要截取
    //初始化图片控制器
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "人人庄园"
        navigationItemBack(title: "      ")
        setCollectionView()
        setTableView()
        setBackgroundColor(color:UIColor.black)
    }
    
    func setCollectionView() -> Void {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width - 20) / 3, height: (view.frame.size.width - 20) / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "LGYPickerImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LGYPickerImageCollectionViewCell")
        collectionView.backgroundColor = UIColor.black
        getPHAsset()
    }
    

    
    
    //  MARK:- 获取全部图片,不分文件类型
    func getPHAsset() -> Void {
        //当然，也可以使用下方的方法直接获取权限的状态
        //search collection data
        let sysfetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

        // 获得相机胶卷
        let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject

        for index in 0..<sysfetchResult.count {
                let assetCollection = sysfetchResult.object(at: index)
                let value = getAssetWith(assetCollection:assetCollection)
                dataScoure.addObjects(from: value)
            let dic = NSMutableDictionary(capacity: 1)
            dic.setValue(value, forKey: "value")
            dic.setValue(assetCollection.localizedLocationNames, forKey: "path")
            dic.setValue(assetCollection.localizedTitle, forKey: "title")
            dataScoureMenu.append(dic)
            
        }
        if cameraRoll != nil {
            let value = getAssetWith(assetCollection:cameraRoll!)
            dataScoure.addObjects(from: value)
            let dic = NSMutableDictionary(capacity: 1)
            dic.setValue(value, forKey: "value")
            dic.setValue(cameraRoll?.localizedLocationNames, forKey: "path")
            dic.setValue((cameraRoll?.localizedTitle!)!, forKey: "title")
            dataScoureMenu.append(dic)
        }
        let dic = NSMutableDictionary(capacity: 1)
        dic.setValue(dataScoure, forKey: "value")
        dic.setValue("", forKey: "path")
        dic.setValue("所有图片", forKey: "title")
        dataScoureMenu.insert(dic, at: 0)
        menuButton.setTitle("所有图片", for: .normal)
    }
    
    //MARK:获取图片的PHAsset，图片信息保存在PHAsset中
    func getAssetWith(assetCollection: PHAssetCollection) -> [PHAsset] {
        //set fetchoptions
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //search
        var assetArray = [PHAsset]()
        let assetFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        for index in 0..<assetFetchResult.count {
            assetArray.append(assetFetchResult[index])
        }
        return assetArray
    }
    
    //MARK:从asset中获得图片
    func getImage(asset:PHAsset,original:Bool,block:((_ image:UIImage?)->Void)?) ->Void{
        let options = PHImageRequestOptions()
        // 是否要原图
        let size = original ? CGSize.init(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelHeight)) : CGSize.init(width: 0, height: 0)
        // 从asset中获得图片
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .default, options: options, resultHandler: {(_ result: UIImage?, _ info: [AnyHashable: Any]?) -> Void in
            if original {
                if info != nil && info!["PHImageFileURLKey"] != nil {
                    block?(result)
                }
            }else{
                 block?(result)
            }
           

        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectMenuIndex == 0 {
            return dataScoure.count+1
        }
        return dataScoure.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LGYPickerImageCollectionViewCell", for: indexPath) as! LGYPickerImageCollectionViewCell
        cell.width.constant = cell.frame.size.width
        if selectMenuIndex == 0 {
            if indexPath.row == 0{
                cell.width.constant = cell.frame.size.width/3
                 cell.prictureImageView.image = UIImage.init(named: "相机.jpg")
            }else{
                
                getImage(asset: dataScoure[indexPath.row-1] as! PHAsset, original: false, block: {(image) in
                    cell.prictureImageView.image = image
                    
                })
            }
        }else{
            getImage(asset: dataScoure[indexPath.row] as! PHAsset, original: false, block: {(image) in
                cell.prictureImageView.image = image
                
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isNeedCut{ //这里是不需要截取图片
            if indexPath.row > 0{
                getImage(asset: dataScoure[indexPath.row-1] as! PHAsset, original: true, block: {[weak self](image) in
                    if let weakSelf = self{
                        weakSelf.delegate?.lgyImageSelectViewController(viewController: weakSelf, image:image!, imagePath: "")
                    }
                })
            }else{
                startCamera();
            }
            return;
        }
        //下面是需要截取图片
        if selectMenuIndex == 0{
            if indexPath.row > 0{
                getImage(asset: dataScoure[indexPath.row-1] as! PHAsset, original: true, block: {[weak self](image) in
                    let clipView = YSHYClipViewController(image: image)
                    clipView?.delegate = self
                    clipView?.clipType = SQUARECLIP
                    //支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
                    
                    //    clipView.scaleRation = 5;// 图片缩放的最大倍数 默认为10
                    if let weakSelf = self{
                        weakSelf.show(clipView!, sender: true)
                    }
                })
            }else{
                      startCamera();
            }
            
        }else{
            getImage(asset: dataScoure[indexPath.row] as! PHAsset, original: true, block: {[weak self](image) in
                let clipView = YSHYClipViewController(image: image)
//                clipView.delegate = self
                clipView?.clipType = SQUARECLIP
                //支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
               
                //    clipView.scaleRation = 5;// 图片缩放的最大倍数 默认为10
                if let weakSelf = self {
                    weakSelf.show(clipView!, sender: true)
                }
            })
           
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            let img = info[UIImagePickerControllerOriginalImage]as?UIImage
             delegate?.lgyImageSelectViewController(viewController: self, image:img!, imagePath: "")
        }
        picker.dismiss(animated: true) {
            
        }
    }
    
    func startCamera()->Void{
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
           
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.camera
            //设置是否允许编辑
            picker.allowsEditing = isNeedCut
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
                
            })
        }else{
            print("读取相册错误")
        }
    }
    //MARK:修改相机Retake 和 use按钮
    func addSomeElements(viewController: UIViewController?) {
        let PLCameraView: UIView? = find(view:viewController?.view, name: "PLCameraView")
        let bottomBar: UIView? = find(view:PLCameraView, name: "PLCropOverlayBottomBar")
        let bottomBarImageForSave: UIImageView? = bottomBar?.subviews.first as? UIImageView
        let retakeButton: UIButton? = bottomBarImageForSave?.subviews.first as? UIButton
        retakeButton?.setTitle("重拍", for: .normal)
        //左下角按钮
        let useButton: UIButton? = bottomBarImageForSave?.subviews[1] as? UIButton
        useButton?.setTitle("上传", for: .normal)
        //右下角按钮
    }
    func find(view:UIView?, name:String?) -> UIView? {
        let cl: AnyClass? = view?.classForCoder
        let desc = cl?.description()
        if (name == desc) {
            return view
        }
        if let ss = view?.subviews.count{
            for i in 0..<ss {
                var subView: UIView? = view?.subviews[i]
                subView = find(view: subView, name: name)
                if subView != nil {
                    return subView
                }
            }
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        addSomeElements(viewController: viewController)
    }
    
    func clipViewController(_ clipViewController: YSHYClipViewController!, finishClipImage editImage: UIImage!) {
        delegate?.lgyImageSelectViewController(viewController: self, image: editImage, imagePath: "")
    }

    
    @IBAction func menuAcition(_ sender: UIButton) {
        var height =  CGFloat(dataScoureMenu.count)*CGFloat(60.0)
        let maxHeight =  CGFloat(UIScreen.main.bounds.size.width - 64 - 60)
        if height > maxHeight{
            height = maxHeight
        }
        tableViewHeightLC.constant = height
        tableView.reloadData()
    }
    
    
    func setTableView() -> Void {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        tableView.separatorColor = UIColor.clear
        tableView.register(UINib.init(nibName: "LGYPickerImageTableViewCell", bundle: nil), forCellReuseIdentifier: "LGYPickerImageTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataScoureMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LGYPickerImageTableViewCell", for: indexPath) as! LGYPickerImageTableViewCell
        cell.selectionStyle = .none
        let dic:NSDictionary = dataScoureMenu[indexPath.row]
        let data = dic.object(forKey: "value") as! NSArray
        if data.count > 0{
            getImage(asset: data[0] as! PHAsset, original: false, block: {(image)in
                cell.prictureImageView.image = image
            })
        }
        cell.pricturePathLabel.text = dic.object(forKey: "path") as? String
        cell.prictureTitleLabel.text = dic.object(forKey: "title") as? String
        cell.prictureCountLabel.text = String(format: "%d张", arguments: [data.count])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMenuIndex = indexPath.row
        let dic:NSDictionary = dataScoureMenu[indexPath.row]
        tableViewHeightLC.constant = 0
        dataScoure = NSMutableArray.init(array: dic.object(forKey: "value") as! NSArray)
        menuButton.setTitle(dic.object(forKey: "title") as? String, for: .normal)
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
