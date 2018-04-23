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
            view.setCollectionView(titleArray: titleArray, imageArray: imageArray)
            
            return view
        }
        
        
        //MARK:设置collectionView
        func setCollectionView(titleArray:Array<String>,imageArray:Array<String>) -> Void {
            dataTitleScoure = titleArray
            dataImageScoure = imageArray
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancle)))
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35)
            let width = (collectionView.frame.size.width - 40)/2
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 40
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize( width:width, height: width)
            collectionView.collectionViewLayout = flowLayout
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib.init(nibName: "ShareViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareViewCell")
            collectionView.bounces = false
           
            
        }
        
        func show() {
             self.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(self)
            //MARK:设置导航栏取消按钮
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1
                self.layoutIfNeeded()
            }) { (finish) in
                
            }
        }
        
       @objc  func cancle(){
            //MARK:设置导航栏取消按钮
            UIView.animate(withDuration: 0.5, animations: {
                 self.alpha = 0
                self.layoutIfNeeded()
            }) { (finish) in
                self.removeFromSuperview()
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareViewCell", for: indexPath) as! ShareViewCell
//            cell.backgroundColor = UIColor(red: 249/255.0, green: 131/255.0, blue: 249/255.0, alpha: 1)
            cell.setDataScoure(imageUrl: dataImageScoure[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            self.delegate?.shareView(shareView:self,selectIndex:indexPath.row)
        }

}
