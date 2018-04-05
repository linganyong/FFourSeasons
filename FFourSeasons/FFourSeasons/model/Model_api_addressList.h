//
//  Model_api_AddressList.h
//  __projectName__
//
//  Created by linganyong on 18/03/30.
//  Copyright © 2018年 linganyong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Addresses;

@interface Model_api_addressList : NSObject

@property (nonatomic, retain) NSArray<Addresses *> * addresses;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString  *token;

@end
