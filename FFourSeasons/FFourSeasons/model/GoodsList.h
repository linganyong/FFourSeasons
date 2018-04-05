//
//  LGYgoodsList.h
//  LGY
//
//  Created by linganyong on 18/03/28.
//  Copyright © 2018年 linganyong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Goods.h"

@interface GoodsList : NSObject

@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;
@property (nonatomic, strong) NSArray<Goods *> * list;
@property (nonatomic, assign) long pageNumber;
@property (nonatomic, assign) long pageSize;
@property (nonatomic, assign) long totalPage;
@property (nonatomic, assign) long totalRow;

@end
