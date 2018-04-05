//
//  Model_sms_verificationCode.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_sms_verificationCode : NSObject
@property (nonatomic,strong) NSString *code; //是否成功
@property (nonatomic,strong) NSString *list; //
@property (nonatomic,strong) NSString *msg;//提示信息
@property (nonatomic,strong) NSString *obj;
@property (nonatomic, assign) long error;
@end
