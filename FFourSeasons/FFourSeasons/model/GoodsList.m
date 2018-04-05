//
//  LGYgoodsList.m
//  LGY
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import "GoodsList.h"
#import "Goods.h"
#import<objc/runtime.h>

@implementation GoodsList

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [Goods class]};
}
@end
