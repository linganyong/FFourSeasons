//
//  ShareView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/26.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

protocol ShareViewDelegate {
    func shareView(shareView:ShareView,selectIndex:NSInteger) ->Void
}

class ShareView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
//        @IBOutlet weak var collectionViewLC: NSLayoutConstraint!
    
        private var collectionViewHeight:CGFloat!
        private var dataTitleScoure:Array<String>!
        private var dataImageScoure:Array<String>!

        
        var delegate:ShareViewDelegate?
    
        class func initShareView(titleArray:Array<String>,imageArray:Array<String>) -> ShareView {
            let view = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)?.first as! ShareView
            LGYTool.viewLayerShadowShadowOffsetHeight(view: view.backView)
            view.setCollectionView(titleArray: titleArray, imageArray: imageArray)
            return view
        }
        
        
        //MARK:设置collectionView
        func setCollectionView(titleArray:Array<String>,imageArray:Array<String>) -> Void {
            dataTitleScoure = titleArray
            dataImageScoure = imageArray
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancle)))
            var count =  CGFloat(1.0)
            if titleArray.count < 4{
                count = CGFloat(titleArray.count)
            }
            let width = (UIScreen.main.bounds.size.width*60.0/75.0)/count-10.0
            collectionViewHeight = 68+30
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize( width:width, height: collectionViewHeight)
            collectionView.collectionViewLayout = flowLayout
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib.init(nibName: "AllClassCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllClassCollectionViewCell")
            collectionView.bounces = false
//            if self.dataTitleScoure.count > 3{
//                self.collectionViewLC.constant = collectionViewHeight * 2+20
//            }else{
//                self.collectionViewLC.constant = collectionViewHeight * 10
//            }
            
        }
        
        func show() {
             self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: self.frame.size.width, height: UIScreen.main.bounds.size.height)
            //MARK:设置导航栏取消按钮
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: -22, width: self.frame.size.width, height: UIScreen.main.bounds.size.height)
                self.collectionView.reloadData()
            }) { (finish) in
                
            }
            
        }
        
       @objc  func cancle(){
            //MARK:设置导航栏取消按钮
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: self.frame.size.width, height: UIScreen.main.bounds.size.height)
                
            }) { (finish) in
                
            }
        }
        
        @IBAction func cancleAction(_ sender: Any) {
            self.delegate?.shareView(shareView: self, selectIndex: -1)
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
            self.delegate?.shareView(shareView:self,selectIndex:indexPath.row)
        }

}
