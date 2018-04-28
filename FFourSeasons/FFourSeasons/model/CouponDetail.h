//
//  CouponDetail.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/21.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponDetail : NSObject
@property (nonatomic, assign) long category;
@property (nonatomic, retain) NSString * created_time;//" = "2018-04-21 20:02:14";
@property (nonatomic, assign) double discount ;// = 0;
@property (nonatomic, retain) NSString * end_time ;//" = "2018-05-29 08:00:00";
@property (nonatomic, retain) NSString * gids;// = "79,78,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102";
@property (nonatomic, retain) NSString * highest_price;//" = "0.00";
@property (nonatomic, assign) long _id;// = 3;
@property (nonatomic, retain) NSString * name;// = asfsdf;
@property (nonatomic, retain) NSString * price;// = "100.00";
@property (nonatomic, retain) NSString * rule;// = safasd;
@property (nonatomic, retain) NSString * start_time ;//" = "2018-04-16 08:00:00";
@property (nonatomic, retain) NSString * total_price ;//" = "1000.00";
@property (nonatomic, retain) NSString *code_id;
@end
