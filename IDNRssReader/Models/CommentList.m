//
//  CommentList.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentList.h"
#import "MyModels.h"
#import "CommentServer.h"
#import "IDNFoundation.h"

@implementation CommentList

- (void)queryAfterRecord:(id)record count:(NSInteger)count callback:(void (^)(NSArray* records, BOOL reachEnd, NSError* error))callback
{
	NSError* error = nil;
	NSArray* comments = nil;
	if(record==nil)
		comments = [[CommentServer server] commentsInRange:NSMakeRange(0, count) linkhash:self.linkhash error:&error];
	else
		comments = [[CommentServer server] commentsAfterComment:record count:count linkhash:self.linkhash error:&error];
	if(callback)
		callback(comments, comments.count==0, error);
}

- (NSComparisonResult)compareRecord:(id)aRecord withRecord:(id)anotherRecord
{
	CommentInfo* comment1 = (CommentInfo*)aRecord;
	CommentInfo* comment2 = (CommentInfo*)anotherRecord;

	return [comment1 compare:comment2];
}

@end