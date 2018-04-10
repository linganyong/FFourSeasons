//
//  Model_api_pay.h
//  FFourSeasons
//
//  Created by 朱李煜 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_api_pay : NSObject


@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;
//支付宝
@property (nonatomic, retain) NSString * pay;
//微信
@property (nonatomic, retain) NSString * noncestr;
@property (nonatomic, retain) NSString * package;
@property (nonatomic, retain) NSString * partnerid;
@property (nonatomic, retain) NSString * prepayid;
@property (nonatomic, retain) NSString * sign;
@property (nonatomic, assign) double timestamp;
@end
