//
//  Model_api_signIn.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model_api_signIn : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, assign) long  integral;

@end
