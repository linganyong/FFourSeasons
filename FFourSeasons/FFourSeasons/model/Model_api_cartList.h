//
//  Model_api_cartList.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/3/30.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CartList;
@interface Model_api_cartList : NSObject
@property (nonatomic, retain) NSArray<CartList *> * cartList;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;
@end
