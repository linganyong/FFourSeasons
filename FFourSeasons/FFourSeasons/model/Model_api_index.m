//
//  Model_api_index.m
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import "Model_api_index.h"
#import "Goods.h"
#import "Shufflings.h"
@implementation Model_api_index


// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [Goods class]
             ,@"shufflings" : [Shufflings class]};
}

@end
