//
//  FarmGoods.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/5.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FarmGoods.h"

@interface FarmGoodsList : NSObject
@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;
@property (nonatomic, retain) NSArray<FarmGoods *> * list;
@property (nonatomic, assign) long pageNumber;
@property (nonatomic, assign) long pageSize;
@property (nonatomic, assign) long totalPage;
@property (nonatomic, assign) long totalRow;
@end
