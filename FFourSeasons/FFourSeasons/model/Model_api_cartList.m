//
//  Model_api_cartList.m
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/30.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import "Model_api_cartList.h"
#import "CartList.h"

@implementation Model_api_cartList

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cartList" : [CartList class]};
}

@end
