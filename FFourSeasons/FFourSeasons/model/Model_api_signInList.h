//
//  Model_api_signInList.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/1.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntegralList.h"

@interface Model_api_signInList : NSObject
@property (nonatomic, assign) BOOL check;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long integral;
@property (nonatomic, retain) IntegralList * list;
@end
