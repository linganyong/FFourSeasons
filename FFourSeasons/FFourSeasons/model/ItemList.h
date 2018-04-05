//
//  Model_itemList.h
//  __projectName__
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Spec;

@interface ItemList : NSObject

@property (nonatomic, assign) long cost;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, assign) long gid;
@property (nonatomic, assign) long _id;
@property (nonatomic, retain) NSString * item_url;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSArray<Spec *> * spec;
@property (nonatomic, retain) NSString * spec_info_id;
@property (nonatomic, assign) long stock;

@end
