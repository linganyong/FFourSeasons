//
//  Model_api_profile.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/30.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_api_profile : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long grade;
@property (nonatomic, retain) NSString * head_url;
@property (nonatomic, assign) long _id;
@property (nonatomic, assign) long integral;
@property (nonatomic, assign) long money;
@property (nonatomic, retain) NSString * nick_name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, assign) long sex;
@property (nonatomic, assign) long user_state;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;

@end
