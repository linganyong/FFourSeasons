//
//  Model_api_goodsDetail.h
//  __projectName__
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Goods;
@class ItemList;

@interface Model_api_goodsDetail : NSObject

@property (nonatomic, retain) Goods * goods;
@property (nonatomic, retain) NSArray<ItemList *> * itemList;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@end
