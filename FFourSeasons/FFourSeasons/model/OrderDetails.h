//
//  OrderDetails.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetails : NSObject
@property (nonatomic, assign) long count;
@property (nonatomic, retain) NSString * created_time;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, assign) long g_id;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long oid;
@property (nonatomic, retain) NSString * small_icon;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * total_price;
@property (nonatomic, assign) long type;
@property (nonatomic,retain) NSString *main_imgs;
@property (nonatomic,retain) NSString *price;

@end
