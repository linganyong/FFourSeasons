//
//  OrderList.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetails.h"

@interface OrderList : NSObject
@property (nonatomic, retain) NSString * comment_time;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, retain) NSArray<OrderDetails *> * detail;
@property (nonatomic, retain) NSString * expires_in;
@property (nonatomic, retain) NSString * freight;
@property (nonatomic, retain) NSString * get_goods_time;
@property (nonatomic, retain) NSString * goods_success_time;
@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, assign) long order_type;
@property (nonatomic, retain) NSString * out_trade_no;
@property (nonatomic, retain) NSString * pay_count;
@property (nonatomic, assign) long pay_integral;
@property (nonatomic, retain) NSString * pay_money;
@property (nonatomic, assign) long pay_status;
@property (nonatomic, retain) NSString * pay_time;
@property (nonatomic, assign) long pay_way;
@property (nonatomic, retain) NSString * prepay_id;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * receive_address;
@property (nonatomic, retain) NSString * receive_located;
@property (nonatomic, retain) NSString * receive_name;
@property (nonatomic, retain) NSString * receive_phone;
@property (nonatomic, retain) NSString * return_goods_time;
@property (nonatomic, retain) NSString * send_goods_time;
@property (nonatomic, retain) NSString * trade_no;
@property (nonatomic, retain) NSString * updated_time;
@property (nonatomic, retain) NSString *coupon_msg; //优惠券信息
@property (nonatomic, retain) NSString *logistic; // 物流单号
@property (nonatomic, retain) NSString *logistic_msg;// 物流信息
@end
