//
//  Farm.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Farm : NSObject
@property (nonatomic, assign) long a_id;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, retain) NSString * recommendation;
@property (nonatomic, retain) NSString * shop_introduce;
@property (nonatomic, retain) NSString * shop_name;
@property (nonatomic, retain) NSString * shop_place;
@property (nonatomic, assign) long shop_state;

@end
