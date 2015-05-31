//
//  CommentServer.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentInfo.h"

@interface CommentServer : NSObject

+ (instancetype)server;

- (CommentInfo*)commentByID:(NSString*)commentID error:(NSError**)error;
- (NSString*)createWithInfo:(CommentInfo*)newComment error:(NSError**)error;

- (NSArray*)commentsInRange:(NSRange)range linkhash:(NSString*)linkhash error:(NSError**)error;
- (NSArray*)commentsAfterComment:(CommentInfo*)comment count:(NSUInteger)count linkhash:(NSString*)linkhash error:(NSError**)error;

@end
