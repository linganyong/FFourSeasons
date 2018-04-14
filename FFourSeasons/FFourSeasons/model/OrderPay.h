//
//  OrderPay.h
//  FFourSeasons
//
//  Created by 朱李煜 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPay : NSObject

@property (nonatomic, retain) NSString * out_trade_no;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long order_type;
@property (nonatomic,assign) long pay_integral;
@end
