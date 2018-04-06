//
//  OrderPage.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/6.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderList.h"

@interface OrderPage : NSObject
@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;
@property (nonatomic, retain) NSArray<OrderList *> * list;
@property (nonatomic, assign) long pageNumber;
@property (nonatomic, assign) long pageSize;
@property (nonatomic, assign) long totalPage;
@property (nonatomic, assign) long totalRow;
@end
