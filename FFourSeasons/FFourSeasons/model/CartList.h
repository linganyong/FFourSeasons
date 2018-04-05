//
//  Model_cartList.h
//  __projectName__
//
//  Created by linganyong on 18/03/30.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartList : NSObject

@property (nonatomic, assign) long cost;
@property (nonatomic, assign) long count;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, assign) long gid;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long item_id; //单品ID
@property (nonatomic, retain) NSString * item_url;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, assign) long u_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, assign) long goods_freight; //
@property (nonatomic, assign) long goods_type; //

@end
