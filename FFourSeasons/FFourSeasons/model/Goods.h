//
//  Model_goods.h
//  __projectName__
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods : NSObject

@property (nonatomic, assign) long cate_id;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, retain) NSString * delivery_address;
@property (nonatomic, retain) NSString * goods_detail;
@property (nonatomic, assign) long goods_freight;
@property (nonatomic, assign) long goods_type;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long is_shelf;
@property (nonatomic, retain) NSString * main_imgs;
@property (nonatomic, retain) NSString * origin_place;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * profile;
@property (nonatomic, assign) long real_sale;
@property (nonatomic, assign) long sale;
@property (nonatomic, assign) long shop_id;
@property (nonatomic, retain) NSString * small_icon;
@property (nonatomic, retain) NSString * spec_info_json;
@property (nonatomic, retain) NSString * spec_json;
@property (nonatomic, assign) long state;
@property (nonatomic, assign) long status;
@property (nonatomic, retain) NSString * title;

@end
