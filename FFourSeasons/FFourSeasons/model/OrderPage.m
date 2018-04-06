//
//  OrderPage.m
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import "OrderPage.h"

@implementation OrderPage
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [OrderList class]};
}
@end
