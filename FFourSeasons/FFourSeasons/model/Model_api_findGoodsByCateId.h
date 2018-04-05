//
//  Model_api_findGoodsByCateId.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/28.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsList.h"
#import "CateList.h"

@interface Model_api_findGoodsByCateId : NSObject
@property (nonatomic, strong) NSArray<CateList *> * cateList;
@property (nonatomic, strong) GoodsList * goodsList;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@end
