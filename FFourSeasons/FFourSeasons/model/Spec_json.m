//
//  spec_json.m
//  __projectName__
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import "Spec_json.h"
#import "SubTag.h"

@implementation Spec_json

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subTag" : [SubTag class]};
}


@end
