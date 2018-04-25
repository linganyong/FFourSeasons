//
//  Model_api_index.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Goods;
@class Shufflings;
@interface Model_api_index : NSObject
@property (nonatomic, retain) NSArray<Goods *> * goodsList;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSArray<Shufflings *> *shufflings;
@property (nonatomic, assign) long speed;
@end
