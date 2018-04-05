//
//  Model_api_integralShop.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsList.h"

@interface Model_api_integralShop : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) GoodsList * goodsList;
@property (nonatomic, retain) NSString * msg;
@end
