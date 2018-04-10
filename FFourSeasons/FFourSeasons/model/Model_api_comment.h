//
//  Model_api_comment.h
//  FFourSeasons
//
//  Created by 林赣泳 on 2018/4/10.
//  Copyright © 2018年 林赣泳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentPage.h"

@interface Model_api_comment : NSObject
@property (nonatomic, strong) CommentPage * page;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, assign) long error;
@property (nonatomic, retain) NSString * msg;
@end
