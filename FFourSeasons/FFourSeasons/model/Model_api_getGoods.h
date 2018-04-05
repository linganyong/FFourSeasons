//
//  Model_api_getGoods.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FarmGoodsList.h"

@interface Model_api_getGoods : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) FarmGoodsList * goodsList;

@end
