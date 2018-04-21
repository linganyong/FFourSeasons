//
//  Model_api_couponList.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/21.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CouponDetail.h"

@interface Model_api_couponList : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSArray<CouponDetail *> *data;
@end
