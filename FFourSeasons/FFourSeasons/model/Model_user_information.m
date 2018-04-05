//
//  Model_user_information.m
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/29.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import "Model_user_information.h"
static NSString * defaultToken;

@implementation Model_user_information

+(void) setToken:(NSString *)str{
    printf("token  ",str);
    defaultToken = str;
}
+(NSString *) getToken{
    if (defaultToken == nil) {
        return @"";
    }
    return defaultToken;
}


@end
