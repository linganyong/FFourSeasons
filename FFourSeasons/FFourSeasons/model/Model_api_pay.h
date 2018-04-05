//
//  Model_api_pay.h
//  FFourSeasons
//
//  Created by 朱李煜 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_api_pay : NSObject

@property (nonatomic, retain) NSString * pay;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;

@end
