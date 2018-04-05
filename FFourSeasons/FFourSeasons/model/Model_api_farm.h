//
//  Model_api_farm.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Farm.h"
@interface Model_api_farm : NSObject
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) Farm * farm;
@property (nonatomic, retain) NSArray<Farm *> * farms;
@end
