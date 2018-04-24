//
//  APIAddress.swift
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/12.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

import UIKit

class APIAddress: NSObject {
     class func api_domainName()->String{
//        return "https://huayanchuang.com"
//        return "http://192.168.1.19:8080"
        return "http://123.207.168.146"
    }
    
    /*
     获取手机短信验证码 已完成
     */
    static let sms_verificationCode = String(format: "%@/sms/send", arguments: [api_domainName()])
    
    /*
     注册账号 已完成
     */
    static let api_register  = String(format: "%@/api/register", arguments: [api_domainName()])
    
    /*
     登录账号 已完成
     */
    static let api_login  = String(format: "%@/api/login", arguments: [api_domainName()])
 
    /*
     获取商品列表和商品分类 已完成
     */
    static let api_findGoodsByCateId = String(format: "%@/api/findGoodsByCateId", arguments: [api_domainName()])
    
    /*
     获取商品列表和商品分类 已完成
     */
    static let api_searchGoods = String(format: "%@/api/searchGoods", arguments: [api_domainName()])
    
    /*
     商品详情 已完成
     */
    static let api_goodsDetail = String(format: "%@/api/goodsDetail", arguments: [api_domainName()])
    
    /*
     商品提交评论 已完成
     */
    static let api_comment = String(format: "%@/api/comment", arguments: [api_domainName()])
    
    /*
     商品评论列表 已完成
     */
    static let api_commentList = String(format: "%@/api/commentList", arguments: [api_domainName()])
    
    
    /*
     首页 已完成
     */
    static let api_index = String(format: "%@/api/index", arguments: [api_domainName()])
    
    /*
     签到领积分 已完成
     */
    static let api_signIn = String(format: "%@/api/signIn", arguments: [api_domainName()])
    
    /*
     购物车列表 已完成
     */
    static let api_cartList = String(format: "%@/api/cartList", arguments: [api_domainName()])
    
    /*
     加入购物车 已完成
     */
    static let api_addCart = String(format: "%@/api/addCart", arguments: [api_domainName()])
    
    /*
     删除购物车 已完成
     */
    static let api_delCart = String(format: "%@/api/delCart", arguments: [api_domainName()])
    
    /*
     添加地址 已完成
     */
    static let api_addAddress = String(format: "%@/api/addAddress", arguments: [api_domainName()])
    
    /*
     地址列表 已完成
     */
    static let api_addressList = String(format: "%@/api/addressList", arguments: [api_domainName()])
    
    /*
     删除地址 已完成
     */
    static let api_delAddress = String(format: "%@/api/delAddress", arguments: [api_domainName()])
    
    /*
     修改地址 已完成
     */
    static let api_alterAddress = String(format: "%@/api/alterAddress", arguments: [api_domainName()])
    
    /*
     选择默认地址 已完成
     */
    static let api_selectAddress = String(format: "%@/api/selectAddress", arguments: [api_domainName()])
    
    /*
     获取个人信息 已完成
     */
    static let api_profile = String(format: "%@/api/profile", arguments: [api_domainName()])
    
    /*
     修改个人信息 已完成
     */
    static let api_editInfo = String(format: "%@/api/editInfo", arguments: [api_domainName()])
    
    /*
     上传图片 已完成
     */
    static let api_upload = String(format: "%@/admin/upload", arguments: [api_domainName()])
    
    /*
     绑定修改手机号码 已完成
     */
    static let api_bindPhone = String(format: "%@/api/bindPhone", arguments: [api_domainName()])
    
    /*
     特权 已完成
     */
    static let api_perks = String(format: "%@/api/perks", arguments: [api_domainName()])
    
    /*
     意见箱 已完成
     */
    static let api_advice = String(format: "%@/api/advice", arguments: [api_domainName()])
    
    /*
     常见问题 注册协议 积分规则 已完成
     */
    static let api_about = String(format: "%@/api/about", arguments: [api_domainName()])
    
    /*
     添加订单 已完成
     */
    static let api_addOrder = String(format: "%@/api/addOrder", arguments: [api_domainName()])
    /*
     生成支付订单 已完成
     */
    static let api_addOrderPay = String(format: "%@/api/addOrderPay", arguments: [api_domainName()])
    
    /*
     支付订单 已完成
     */
    static let api_toPay = String(format: "%@/api/toPay", arguments: [api_domainName()])
    
    /*
     订单列表
     */
    static let api_orderList = String(format: "%@/api/orderList", arguments: [api_domainName()])
    
    /*
     订单详情
     */
    static let api_orderDetail = String(format: "%@/api/orderDetail", arguments: [api_domainName()])
    
    /*
     删除订单
     */
    static let api_cancelOrder = String(format: "%@/api/cancelOrder", arguments: [api_domainName()])
    
    /*
     确定收货
     */
    static let api_confirmOrder = String(format: "%@/api/confirmOrder", arguments: [api_domainName()])
    
    /*
     充值
     */
    static let api_topUp = String(format: "%@/api/topUp", arguments: [api_domainName()])
    
    /*
     积分商城 已完成
     */
    static let api_integralShop = String(format: "%@/api/integralShop", arguments: [api_domainName()])
    
    /*
     签到列表 已完成
     */
    static let api_signInList = String(format: "%@/api/signInList", arguments: [api_domainName()])
    
    /*
     修改支付密码 已完成
     */
    static let api_alterPayPw = String(format: "%@/api/alterPayPw", arguments: [api_domainName()])
    
    /*
     忘记密码 已完成
     */
    static let api_alterPw = String(format: "%@/api/alterPw", arguments: [api_domainName()])
    
    /*
     获取周边农场信息
     */
    static let api_getFarm = String(format: "%@/api/getFarm", arguments: [api_domainName()])
    
    /*
     获取周边农场产品信息
     */
    static let api_getGoods = String(format: "%@/api/getGoods", arguments: [api_domainName()])
    
    /*
     修改密码
     */
    static let api_alterUserPw = String(format: "%@/api/alterUserPw", arguments: [api_domainName()])
    
    /*
     售后申请
     */
    static let api_customerService = String(format: "%@/api/customerService", arguments: [api_domainName()])
    
    /*
     取消售后
     */
    static let api_cancelService = String(format: "%@/api/cancelService", arguments: [api_domainName()])
    
    /*
     邀请码
     */
    static let api_inviteCode = String(format: "%@/api/inviteCode", arguments: [api_domainName()])
    
    /*
     兑换优惠券
     */
    static let api_exchangeCoupon = String(format: "%@/api/exchangeCoupon", arguments: [api_domainName()])
    
    /*
     用户的优惠券
     */
    static let api_couponList = String(format: "%@/api/couponList", arguments: [api_domainName()])
    
    /*
     下单的优惠券
     */
    static let api_addOrderCouponList = String(format: "%@/api/addOrderCouponList", arguments: [api_domainName()])
    
    /*
     兑换优惠券
     */
    static let api_bindInvite = String(format: "%@/api/bindInvite", arguments: [api_domainName()])
    
    /*
     物流
     */
    static let api_query = String(format: "%@/api/query", arguments: [api_domainName()])
    
}
