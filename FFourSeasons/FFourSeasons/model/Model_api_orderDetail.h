//
//  Model_api_orderDetail.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/9.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderDetails.h"
#import "OrderList.h"
@interface Model_api_orderDetail : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) OrderList *orderPay;
@property (nonatomic, retain) NSArray<OrderDetails *> *recordList;
@end
