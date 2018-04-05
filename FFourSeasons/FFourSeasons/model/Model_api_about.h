//
//  About.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_api_about : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * problem; //常见问题
@property (nonatomic, retain) NSString * agreement; //注册协议
@property (nonatomic, retain) NSString * rule; //积分规则
@property (nonatomic, retain) NSString * birth; //生日特权
@property (nonatomic, retain) NSString * vip; //vip特权
@end
