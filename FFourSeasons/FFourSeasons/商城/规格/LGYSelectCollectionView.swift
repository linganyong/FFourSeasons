//
//  LGYSelectCollectionView.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/2/26.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

typealias CallBlock = (_ countStr:String ,_ array:Array<String>?)->Void

class LGYSelectCollectionView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var dataScoure:Array<Spec_json>?
    var callBlock:CallBlock?
    var maginLeft = 16
    var selectIndexPaths = NSMutableArray(object: 0)
    
    @IBOutlet private weak var collectionView: UICollectionView!
     @IBOutlet private weak var countTextField: UITextField!
    
    @IBOutlet weak var collectionViewHieightLC: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    
    
     func collectionViewStyle(array:Array<Spec_json>?) -> Void {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(cancle))
        backView.addGestureRecognizer(tap)
        if array == nil || array?.count == 0{
            self.collectionViewHieightLC.constant = 0
            
            return
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "LGYSelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LGYSelectCollectionViewCell")
        collectionView.register(UINib.init(nibName: "LGYSelectCollectionViewReusableView", bundle: nil), forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "LGYSelectCollectionViewReusableView")
        let flowLayout = LGYMaxCollectionViewFlowLayout()
        flowLayout.maxInteritemSpacing = 12
        collectionView.collectionViewLayout = flowLayout
        
        if #available(iOS 11.0, *) {
            collectionView.accessibilityContainerType = .none
        } else {
            // Fallback on earlier versions
        }
        if array == nil{
            dataScoure = Array<Spec_json>()
        }else{
            dataScoure = array
    
        }
        collectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LGYSelectCollectionViewCell", for: indexPath) as! LGYSelectCollectionViewCell
         cell.setText(text: getText(indexPath: indexPath))
        
        var flag = false
        for item in selectIndexPaths{
            let index = item as? IndexPath
            if index?.row == indexPath.row && index?.section == indexPath.section {
                flag = true
            }
        }
        if flag {
            cell.selectStyle()
        }else{
            cell.defualtStyle()
        }
        collectionViewHightAnimation(indexPath: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return (dataScoure?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let item = dataScoure![section]
        let count = item.subTag.count
        if count > 0{
            self.collectionViewHieightLC.constant = 600
        }
        return count
    }
    
    func getText(indexPath:IndexPath) -> String? {
        let item = dataScoure![indexPath.section]
        let subTag = item.subTag[indexPath.row] as! SubTag
        return subTag.name
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = LGYTool.stringSize(string: getText(indexPath: indexPath)!, font: UIFont.systemFont(ofSize: 8.0), maxSize: CGSize(width: collectionView.frame.size.width, height: 10))
        
        
        return CGSize(width: size.width+16, height: 20)
    }
    //MARK:绘制第几个indexpath的时候开始，动画修改高度
    func collectionViewHightAnimation(indexPath:IndexPath) -> Void {
         let item = dataScoure![indexPath.section]
        if indexPath.section == (dataScoure?.count)!-1  && indexPath.row == item.subTag.count-1 {
            if  self.collectionViewHieightLC.constant == self.collectionView.contentSize.height && self.collectionView.contentSize.height < UIScreen.main.bounds.size.height - 120 {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                if self.collectionView.contentSize.height < UIScreen.main.bounds.size.height - 120{
                    self.collectionViewHieightLC.constant = self.collectionView.contentSize.height
                }else{
                    self.collectionViewHieightLC.constant = UIScreen.main.bounds.size.height - 120
                }
                self.layoutIfNeeded()
            }, completion: { (finish) in
                
            })
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 12
    }
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 12
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 15, 5, 15) //分别为上、左、下、右
    }
    
    @objc func cancle() -> Void {
        self.removeFromSuperview()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "LGYSelectCollectionViewReusableView", for: indexPath) as! LGYSelectCollectionViewReusableView
         let item = dataScoure![indexPath.section]
        reusableView.textLabel.text = item.name
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var flag = true
        for s in selectIndexPaths{
            let index = s as? IndexPath
            if index != nil && index?.section == indexPath.section {
                if index?.row == indexPath.row {
                    flag = false
                }
                selectIndexPaths.remove(index!)
            }
        }
        if flag {
            selectIndexPaths.add(indexPath)
        }
         collectionView.reloadSections([indexPath.section])
    }
    
    
    
    //MARK:添加响应
    @IBAction private func addAction(_ sender: Any) {
        var count = Int(countTextField.text!)!
        count += 1
            countTextField.text = String(format: "%d", arguments: [count])
        
    }
    
    //MARK:减少响应
    @IBAction private func subtractionAction(_ sender: Any) {
        var count = Int(countTextField.text!)!
        if count > 0{
            count -= 1
            countTextField.text = String(format: "%d", arguments: [count])
        }
        
    }
    
    
    @IBAction private func sureAction(_ sender: Any) {
       var array = Array<String>()
        if dataScoure != nil && (dataScoure?.count)! > 0{
            if selectIndexPaths.count-1 != (dataScoure?.count)!{
                array.append("$%^&")
            }
            if selectIndexPaths.count>0{
                for s in selectIndexPaths {
                    let item = s as? IndexPath
                    if item != nil{
                        let index = dataScoure![(item?.section)!]
                        let subTag = index.subTag[(item?.row)!] as! SubTag
                        array.append(subTag.name)
                    }
                }
            }
        }
        
        callBlock?(countTextField.text!,array)
        
    }
//    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
}
