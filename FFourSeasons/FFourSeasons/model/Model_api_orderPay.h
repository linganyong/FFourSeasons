//
//  Model_api_orderPay.h
//  FFourSeasons
//
//  Created by 朱李煜 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderList.h"

@interface Model_api_orderPay : NSObject

@property (nonatomic, retain) OrderList * orderPay;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;

@end
