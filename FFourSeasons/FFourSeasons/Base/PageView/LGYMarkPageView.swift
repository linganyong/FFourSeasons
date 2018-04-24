//
//  LGYMarkPageView.swift
//  HuaXiaYiKeIosApp
//
//  Created by LGY  on 2018/1/15.
//  Copyright © 2018年 LGY . All rights reserved.
//

import UIKit

protocol LGYMarkPageViewDelegate {
     func markPageView(pageView:LGYMarkPageView,showIndex:NSInteger) ->Void
}

class LGYMarkPageView: UIView,UIScrollViewDelegate {
    
    private let _headerView = UIScrollView()
    private var _headerHeight = CGFloat(80.00)
    private let _headerLineView = UIView()
    private let _contentView = UIScrollView()
    private var _titleArray:Array<String>?
    private var _count = 0
    private var _headerButtonMagin = CGFloat(80.00)
    private var _headerButtonHeight = CGFloat(30.00)
    private var _defaultTextColor:UIColor?
    private var _selectTextColor:UIColor?
    private var _defaultBackgroundColor:UIColor?
    private var _selectBackgroundColor:UIColor?
    private var _headerLineHeight = CGFloat(2.00)
    private var _maginLeft:CGFloat!
    private var _selectIndex = 0
    private var _buttonTextFont = UIFont.systemFont(ofSize: 15)
    private var _oldSelectIndex = 0
    private var width = CGFloat(0.0)
    public var delegate:LGYMarkPageViewDelegate?
    
    let allClassButton = UIButton() //所有菜单点击按钮
    let allClassImageView = UIImageView()
    //MARK:设置布局
    func frameLayout() -> Void {
        _headerView.addSubview(_headerLineView)
        self.addSubview(_headerView)
        self.addSubview(_contentView)
        _headerView.isHidden = false
        _headerView.frame = CGRect(x: 0, y: 4, width: self.bounds.size.width-_headerHeight-16-4, height: _headerHeight)
        _headerView.showsVerticalScrollIndicator = false
        _headerView.showsHorizontalScrollIndicator = false
        headerButtonAdd()
        _contentView.frame = CGRect(x: 0, y:_headerView.frame.size.height+20+4, width: self.bounds.size.width, height: self.frame.size.height - _headerView.frame.size.height+_headerView.frame.origin.y - 24);
        allClassButton.frame = CGRect(x: self.bounds.size.width-_headerHeight-16, y: 4, width: _headerHeight, height: _headerHeight+16)
        allClassImageView.frame = CGRect(x:0, y: 0, width: _headerHeight, height: _headerHeight)
        allClassButton.contentMode = .scaleAspectFit
        allClassImageView.image = UIImage.init(named: "应用3x.png")
        allClassButton.addSubview(allClassImageView)
        self.addSubview(allClassButton)
        contentViewAdd()
    }
    
    
    
    //MARK:添加内容
    func addContent(titleArray:Array<String>,height:CGFloat,maginLeft:CGFloat) -> Void {
        //去除多余的
        if _count < titleArray.count{
            for i in _count...titleArray.count {
                _contentView.viewWithTag(2000+i)?.removeFromSuperview()
                _headerView.viewWithTag(1000+i)?.removeFromSuperview()
            }
        }
        //设置内容
        _titleArray = titleArray;
        _headerButtonHeight = height
        _count = (_titleArray?.count)!;
        _maginLeft = maginLeft
        _contentView.delegate = self
    }
    
    //MARK:添加头部标题栏设置
    func headerBtnStyle(defaultTextColor:UIColor,selectTextColor:UIColor,headerBtnMagin:CGFloat,headerLineHeight:CGFloat,textFront:Float){
        _headerButtonMagin = headerBtnMagin
        _selectTextColor = selectTextColor
        _defaultTextColor = defaultTextColor
        _headerLineHeight = headerLineHeight
        _headerHeight = _headerButtonHeight+_headerLineHeight
        _buttonTextFont = UIFont.systemFont(ofSize: CGFloat(textFront))
        frameLayout()
    }
    
    func setBackgroundColor(defaultBackgroundColor:UIColor,selectBackgroundColor:UIColor) -> Void {
        _defaultBackgroundColor = defaultBackgroundColor
        _selectBackgroundColor = selectBackgroundColor
    }
    
    //MARK:添加头部标题栏设置
    private func headerButtonAdd() -> Void {
        width = _headerButtonMagin/2
        if _count == 0{
            return;
        }
        for i in 0..._count-1 {
            var item = self.viewWithTag(1000+i) as? UIButton
            if item == nil {
                item = UIButton()
                item?.tag = 1000+i
                item?.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
                item?.LGyCornerRadius = 10
                _headerView.addSubview(item!)
            }
            let string = NSString.init(format: "   %@   ", _titleArray![i]) as String
            let size = LGYTool.stringSize(string: string, font: _buttonTextFont, maxSize: CGSize(width: 1000, height: 21))
            item?.frame =  CGRect(x: width, y: 0, width: size.width, height:_headerButtonHeight)
            width += _maginLeft*2
            width += size.width
            item?.titleLabel?.font = _buttonTextFont
            item?.setTitle(_titleArray?[i], for: .normal)
            item?.setTitleColor(_defaultTextColor, for: .normal)
        }
        _headerView.contentSize = CGSize(width: width + _headerButtonMagin/2, height: _headerView.frame.size.height)
        _headerLineView.frame = CGRect(x: CGFloat(_selectIndex)*width, y:_headerButtonHeight, width: _headerButtonMagin, height: _headerLineHeight)
        _headerLineView.backgroundColor = _selectTextColor
        pageViewButton(index: _selectIndex)?.setTitleColor(_selectTextColor, for: .normal)
        pageViewButton(index: _selectIndex)?.backgroundColor = _selectBackgroundColor
    }
    
    //MARK:添加TableView
    private func contentViewAdd(){
        if _count == 0{
            return;
        }
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
        if scrollView == _headerView{
            return
        }
        if _headerView.contentSize.width > _headerView.frame.size.width{
            //横向移动
            let x = scrollView.contentOffset.x*((_headerView.contentSize.width - _headerView.frame.size.width)/scrollView.contentSize.width)
            _headerView.contentOffset = CGPoint(x: x, y: 0)
        }
            _selectIndex = Int( (scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width)
            if _oldSelectIndex != _selectIndex{
                
                pageViewButton(index: _oldSelectIndex)?.setTitleColor(_defaultTextColor, for: .normal)
                pageViewButton(index: _oldSelectIndex)?.backgroundColor = _defaultBackgroundColor
                
                pageViewButton(index: _selectIndex)?.setTitleColor(_selectTextColor, for: .normal)
                pageViewButton(index: _selectIndex)?.backgroundColor = _selectBackgroundColor
                _oldSelectIndex = _selectIndex
                
                delegate?.markPageView(pageView: self, showIndex:  _selectIndex)
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
    
}

