//
//  Model_api_addOrder.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Addresses.h"
#import "CartList.h"

@interface Model_api_addOrder : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) Addresses * address;
@property (nonatomic, retain) NSArray<CartList *> * list;
@property (nonatomic, retain) NSString *payMoney;
@property (nonatomic, retain) NSString *totalFreight;
@end
