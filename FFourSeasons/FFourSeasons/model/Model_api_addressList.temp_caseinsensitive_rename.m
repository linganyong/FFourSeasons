//
//  Model_api_AddressList.m
//  __projectName__
//
//  Created by linganyong on 18/03/30.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import "Model_api_AddressList.h"
#import "Addresses.h"

@implementation Model_api_AddressList

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"addresses" : [Addresses class]};
}

@end
