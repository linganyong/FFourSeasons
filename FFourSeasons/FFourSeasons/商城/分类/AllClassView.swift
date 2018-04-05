//
//  AllClassView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/10.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias AllClassViewSelectBlock =  (_ allClassView:AllClassView,_ selectIndex:NSInteger) -> Void

class AllClassView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var allClassCollectionView: UICollectionView!
    @IBOutlet weak var allClassCollectionViewLC: NSLayoutConstraint!
    
    private var collectionViewHeight:CGFloat!
    private var dataTitleScoure:Array<String>!
    private var dataImageScoure:Array<String>!
    
    var selectIndexBlock:AllClassViewSelectBlock?
    
    class func initAllClassView(titleArray:Array<String>,imageArray:Array<String>) -> AllClassView {
        let view = Bundle.main.loadNibNamed("AllClassView", owner: nil, options: nil)?.first as! AllClassView
        view.setCollectionView(titleArray: titleArray, imageArray: imageArray)
        return view
    }
    
    
    //MARK:设置collectionView
    func setCollectionView(titleArray:Array<String>,imageArray:Array<String>) -> Void {
        dataTitleScoure = titleArray
        dataImageScoure = imageArray
        
        let width = (UIScreen.main.bounds.size.width*60.0/75.0)/3.0-20.0
        collectionViewHeight = width*36/60+30+21
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize( width:width, height: collectionViewHeight)
        allClassCollectionView.collectionViewLayout = flowLayout
        allClassCollectionView.delegate = self
        allClassCollectionView.dataSource = self
        allClassCollectionView.register(UINib.init(nibName: "AllClassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllClassCollectionViewCell")
        allClassCollectionView.bounces = false
        if self.dataTitleScoure.count%3 == 0{
            self.allClassCollectionViewLC.constant = CGFloat(self.dataTitleScoure.count/3)*self.collectionViewHeight+self.collectionViewHeight*9/19
        }else{
            self.allClassCollectionViewLC.constant = CGFloat(self.dataTitleScoure.count/3+1)*self.collectionViewHeight+self.collectionViewHeight*9/19
        }
        
        if self.allClassCollectionViewLC.constant > UIScreen.main.bounds.size.height - 120
        {
            self.allClassCollectionViewLC.constant = UIScreen.main.bounds.size.height - 120
        }
    }
    
    func show() {
        //MARK:设置导航栏取消按钮
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: 0, y: 22, width: self.frame.size.width, height: self.frame.size.height)
            self.allClassCollectionView.reloadData()
        }) { (finish) in
            
        }
        
    }
    
    func cancle(){
        //MARK:设置导航栏取消按钮
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: 0, y: -UIScreen.main.bounds.size.height, width: self.frame.size.width, height: self.frame.size.height)
            
        }) { (finish) in
            
        }
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        selectIndexBlock?(self,-1)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataTitleScoure.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllClassCollectionViewCell", for: indexPath) as! AllClassCollectionViewCell
        cell.setDataScoure(imageUrl: dataImageScoure[indexPath.row], name: dataTitleScoure[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectIndexBlock?(self,indexPath.row)
    }

}
