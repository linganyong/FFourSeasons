//
//  Model_api_goodsDetail.m
//  __projectName__
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import "Model_api_goodsDetail.h"
#import "Goods.h"
#import "ItemList.h"

@implementation Model_api_goodsDetail




// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"itemList" : [ItemList class]};
}
@end
