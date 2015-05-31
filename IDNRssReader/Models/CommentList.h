//
//  CommentList.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SegmentQuery.h"
#import "CommentInfo.h"

@interface CommentList : SegmentQuery

@property(nonatomic,strong) NSString* linkhash;

- (void)asyncMoreWithFinishedBlock:(void (^)(NSError*error))finished;
- (void)asyncRefreshWithFinishedBlock:(void (^)(NSError*error))finished;
- (void)asyncReloadWithFinishedBlock:(void (^)(NSError*error))finished;

@end