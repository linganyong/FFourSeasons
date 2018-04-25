//
//  LGYPageView.swift
//  HuaXiaYiKeIosApp
//
//  Created by LGY  on 2018/1/15.
//  Copyright © 2018年 LGY . All rights reserved.
//

import UIKit

class LGYPageView: UIView,UIScrollViewDelegate {
    private let _headerView = UIScrollView()
    private var _headerHeight = CGFloat(80.00)
    private let _headerLineView = UIView()
    private let _contentView = UIScrollView()
    private var _titleArray:Array<String>?
    private var _count = 0
    private var _headerButtonWidth = CGFloat(80.00)
    private var _headerButtonHeight = CGFloat(30.00)
    private var _defaultTextColor:UIColor?
    private var _selectTextColor:UIColor?
    private var _headerLineHeight = CGFloat(2.00)
    private var _headerViewHidden = true
    private var _selectIndex = 0
    private var _buttonTextFont = UIFont.systemFont(ofSize: 15)
    private var _oldSelectIndex = 0
    private var _headerLineViewWidht = CGFloat(60)
    
    //MARK:设置布局
    func frameLayout() -> Void {
        self.layoutIfNeeded()
        _headerView.addSubview(_headerLineView)
        self.addSubview(_headerView)
        self.addSubview(_contentView)
        if _headerViewHidden {
            _headerView.isHidden = true
            _contentView.frame = CGRect(x: 0, y:0, width: self.bounds.size.width, height: self.frame.size.height);
        }else{
            _headerView.isHidden = false
            _headerView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: _headerHeight)
            _headerView.showsVerticalScrollIndicator = false
            _headerView.showsHorizontalScrollIndicator = false
            headerButtonAdd()
            _contentView.frame = CGRect(x: 0, y:_headerView.frame.size.height, width: self.bounds.size.width, height: self.frame.size.height - _headerHeight);
            _contentView.showsVerticalScrollIndicator = false
            _contentView.showsHorizontalScrollIndicator = false
        }
        contentViewAdd()
        self.layoutIfNeeded()
        _headerView.contentOffset = CGPoint(x: 0, y: 0)
//        self.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath!.elementsEqual("frame") && (change![NSKeyValueChangeKey.newKey] != nil){
//            self.frameLayout()
//        }
//    }
    
    
    //MARK:添加内容
    func addContent(titleArray:Array<String>,height:CGFloat,isHiddenHeader:Bool) -> Void {
        //去除多余的
        for i in _count...titleArray.count {
            _contentView.viewWithTag(2000+i)?.removeFromSuperview()
            _headerView.viewWithTag(1000+i)?.removeFromSuperview()
        }
        //设置内容
        _titleArray = titleArray;
        _headerButtonHeight = height
        _count = (_titleArray?.count)!;
        _headerViewHidden = isHiddenHeader
        if isHiddenHeader{
            frameLayout()
        }
        _contentView.delegate = self
    }
    
    //MARK:添加头部标题栏设置
    func headerBtnStyle(defaultTextColor:UIColor,selectTextColor:UIColor,headerBtnWidth:CGFloat,headerLineHeight:CGFloat,textFront:Float){
        _headerButtonWidth = headerBtnWidth
        _headerLineViewWidht = headerBtnWidth
        _selectTextColor = selectTextColor
        _defaultTextColor = defaultTextColor
        _headerLineHeight = headerLineHeight
        _headerHeight = _headerButtonHeight+_headerLineHeight
        _buttonTextFont = UIFont.systemFont(ofSize: CGFloat(textFront))
        frameLayout()
    }
    
    //MARK:添加头部标题栏设置
  private func headerButtonAdd() -> Void {
        for i in 0..._count-1 {
            var item = self.viewWithTag(1000+i) as? UIButton
            if item == nil {
                item = UIButton()
                item?.tag = 1000+i
                item?.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
                _headerView.addSubview(item!)
            }
            item?.frame =  CGRect(x: _headerButtonWidth*CGFloat(i), y: 0, width: _headerButtonWidth, height:_headerButtonHeight)
            item?.titleLabel?.font = _buttonTextFont
            item?.setTitle(_titleArray?[i], for: .normal)
            item?.setTitleColor(_defaultTextColor, for: .normal)
        }
        _headerView.contentSize = CGSize(width: _headerButtonWidth*CGFloat(_count), height: _headerView.frame.size.height)
        _headerLineView.frame = CGRect(x: CGFloat(_selectIndex)*_headerButtonWidth + (_headerButtonWidth - _headerLineViewWidht)/2, y:_headerButtonHeight, width:_headerLineViewWidht, height: _headerLineHeight)
        _headerLineView.backgroundColor = _selectTextColor
        pageViewButton(index: _selectIndex)?.setTitleColor(_selectTextColor, for: .normal)
    
    }
    
    func setLineViewWidth(width:CGFloat) ->Void{
        _headerLineViewWidht = width
        _headerLineView.frame = CGRect(x: _headerLineView.frame.origin.x+(_headerButtonWidth - _headerLineViewWidht)/2, y: _headerLineView.frame.origin.y, width:  _headerLineViewWidht, height:  _headerLineView.frame.size.height)
    }
    
    //MARK:添加TableView
    private func contentViewAdd(){
        for i in 0..._count-1 {
            var item = self.viewWithTag(2000+i) as? UITableView
            if item == nil {
                item = UITableView()
                item?.separatorColor = UIColor.clear
                item?.tag = 2000+i
                _contentView.addSubview(item!)
            }
            item?.frame = CGRect(x: _contentView.frame.size.width*CGFloat(i), y: 0, width: _contentView.frame.size.width, height: _contentView.frame.size.height)
            
        }
        _contentView.isPagingEnabled = true
        _contentView.contentSize = CGSize(width: _contentView.frame.size.width*CGFloat(_count), height: _contentView.frame.size.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !_headerViewHidden{
            //横向移动
            let x = scrollView.contentOffset.x*(_headerView.contentSize.width/scrollView.contentSize.width)
            _headerLineView.frame = CGRect(x: x+(_headerButtonWidth - _headerLineViewWidht)/2, y: _headerLineView.frame.origin.y, width:  _headerLineView.frame.size.width, height:  _headerLineView.frame.size.height)
            if scrollView == _contentView && _headerView.contentSize.width > _headerView.frame.width+1{
                let scale = (scrollView.contentSize.width-scrollView.frame.width)/(_headerView.contentSize.width - _headerView.frame.width)
                _headerView.contentOffset.x = scrollView.contentOffset.x/scale
            }
//            if scale == 0.0{
                _selectIndex = Int( (scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width)
                if _oldSelectIndex != _selectIndex{
                    pageViewButton(index: _oldSelectIndex)?.setTitleColor(_defaultTextColor, for: .normal)
                    pageViewButton(index: _selectIndex)?.setTitleColor(_selectTextColor, for: .normal)
                    _oldSelectIndex = _selectIndex
                }
//                return
//            }
        }
    }
    
    //MARK:选择第几个菜单
    func select(index:Int) -> Void {
        _contentView.setContentOffset(CGPoint.init(x: _contentView.frame.size.width * CGFloat(index), y: 0), animated: true)
    }
    
    //MARK:菜单点击响应
    @objc private func buttonAction(sender:UIButton) -> Void {
        select(index: sender.tag - 1000)
    }
    
    
    //MARK:返回index位置的tableView
    func pageViewtableView(index:Int) -> UITableView?{
        return _contentView.viewWithTag(2000+index) as? UITableView
    }
    
    //MARK:返回index位置的Button
    func pageViewButton(index:Int) -> UIButton?{
        return _headerView.viewWithTag(1000+index) as? UIButton
    }
    
//    deinit {
//        self.removeObserver(self, forKeyPath: "frame")
//    }
}

