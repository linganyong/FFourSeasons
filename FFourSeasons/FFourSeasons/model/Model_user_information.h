//
//  Model_user_information.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/29.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Model_user_information : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;

+(void) setToken:(NSString *)str;
+(NSString *) getToken;


@end
