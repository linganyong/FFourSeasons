//
//  Model_api_searchGoods.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/8.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsList.h"

@interface Model_api_searchGoods : NSObject
@property (nonatomic, strong) GoodsList * goodsList;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@end
