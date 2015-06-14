//
//  CommentList.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentList.h"
#import "MyModels.h"
#import "IDNAsyncTask.h"
#import "CommentServer.h"
#import "IDNFoundation.h"

@implementation CommentList
{
	id taskGroup;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		taskGroup = [NSValue valueWithNonretainedObject:self];
	}
	return self;
}

- (void)dealloc
{
	[IDNAsyncTask cancelAllTasksInGroup:taskGroup];
}

- (NSArray*)queryAfterRecord:(id)record count:(NSInteger)count error:(NSError**)error
{
	if(record==nil)
		return [[CommentServer server] commentsInRange:NSMakeRange(0, count) linkhash:self.linkhash error:error];
	return [[CommentServer server] commentsAfterComment:record count:count linkhash:self.linkhash error:error];
}

- (NSComparisonResult)compareRecord:(id)aRecord withRecord:(id)anotherRecord
{
	CommentInfo* comment1 = (CommentInfo*)aRecord;
	CommentInfo* comment2 = (CommentInfo*)anotherRecord;

	return [comment1 compare:comment2];
}

- (BOOL)isRecordModifiedWithOldInfo:(id)oldInfo newInfo:(id)newInfo
{
	return NO;
}

- (void)asyncMoreWithFinishedBlock:(void (^)(NSError*error))finished;
{
	[IDNAsyncTask putTask:^id{
		return [self more];
	} finished:^(NSError* error) {
		if(finished)
			finished(error);
	} cancelled:^{
		if (finished)
			finished([NSError errorDescription:@"操作取消"]);
	} group:taskGroup];
}
- (void)asyncRefreshWithFinishedBlock:(void (^)(NSError*error))finished;
{
	[IDNAsyncTask putTask:^id{
		return [self refresh];
	} finished:^(NSError* error) {
		if(finished)
			finished(error);
	} cancelled:^{
		if (finished)
			finished([NSError errorDescription:@"操作取消"]);
	} group:taskGroup];
}
- (void)asyncReloadWithFinishedBlock:(void (^)(NSError*error))finished;
{
	[IDNAsyncTask putTask:^id{
		return [self reload];
	} finished:^(NSError* error) {
		if(finished)
			finished(error);
	} cancelled:^{
		if (finished)
			finished([NSError errorDescription:@"操作取消"]);
	} group:taskGroup];
}

@end