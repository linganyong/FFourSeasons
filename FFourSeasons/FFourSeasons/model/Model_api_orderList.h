//
//  Model_api_orderList.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPage.h"

@interface Model_api_orderList : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) OrderPage * page;
@end
