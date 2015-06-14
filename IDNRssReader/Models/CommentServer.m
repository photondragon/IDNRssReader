//
//  CommentServer.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentServer.h"
#import "IDNNetwork.h"
#import "RRConstant.h"
#import "IDNFoundation.h"

@implementation CommentServer

+ (instancetype)server
{
	static CommentServer* server = nil;
	if(server==nil)
	{
		server = [[CommentServer alloc] init];
	}
	return server;
}

- (NSString*)urlOfComments
{
	return [NSString stringWithFormat:@"%@/api/comments", RRHostName];
}

- (NSString*)urlOfComment:(NSString*)infoID
{
	return [NSString stringWithFormat:@"%@/api/comments/%@", RRHostName, infoID];
}

- (CommentInfo*)commentByID:(NSString*)commentID error:(NSError**)error
{
	NSDictionary* dicResponse = [IDNNetwork getDictionaryFromURL:[self urlOfComment:commentID] parameters:nil error:error];
	if(dicResponse==nil)
		return nil;
	int err = [dicResponse[@"errcode"] intValue];
	if(err==0)//成功
	{
		CommentInfo* comment = [[CommentInfo alloc] initWithInfoDict:dicResponse[@"data"]];
		if(error) *error = nil;
		return comment;
	}
	if(error) *error = [NSError errorWithDomain:RRErrorDomainServer description:dicResponse[@"errdesc"]];
	return nil;
}

- (NSString*)createWithInfo:(CommentInfo*)newInfo error:(NSError**)error;
{
	NSDictionary* dicComment = [newInfo infoDictOfSubmission];
	NSDictionary* dicResponse = [IDNNetwork postToURL:[self urlOfComments] parameters:dicComment error:error];
	if(dicResponse==nil)
		return nil;
	int err = [dicResponse[@"errcode"] intValue];
	if(err==0)
	{
		NSString* commentId = dicResponse[@"data"][@"id"];
		if(error) *error = nil;
		return commentId;
	}
	if(error) *error = [NSError errorWithDomain:RRErrorDomainServer description:dicResponse[@"errdesc"]];
	return nil;
}

- (NSArray*)commentsByParameters:(NSDictionary*)parameters error:(NSError**)error
{
	NSDictionary* dicResponse = [IDNNetwork getDictionaryFromURL:[self urlOfComments] parameters:parameters error:error];
	if(dicResponse==nil)
		return nil;
	int err = [dicResponse[@"errcode"] intValue];
	if(err==0)//成功
	{
		NSArray* arrayInfoDicts = dicResponse[@"data"];
		NSMutableArray* arrayComments = [NSMutableArray array];
		for (NSDictionary* dicComment in arrayInfoDicts) {
			CommentInfo* comment = [[CommentInfo alloc] initWithInfoDict:dicComment];
			[arrayComments addObject:comment];
		}
		if(error) *error = nil;
		return arrayComments;
	}
	if(error) *error = [NSError errorWithDomain:RRErrorDomainServer description:dicResponse[@"errdesc"]];
	return nil;
}

- (NSArray*)commentsInRange:(NSRange)range linkhash:(NSString*)linkhash error:(NSError**)error;
{
	NSDictionary* parameters = @{
								 @"start":@(range.location),
								 @"count":@(range.length),
								 @"linkhash":linkhash,
								 };
	return [self commentsByParameters:parameters error:error];
}

- (NSArray*)commentsAfterComment:(CommentInfo*)comment count:(NSUInteger)count linkhash:(NSString*)linkhash error:(NSError**)error;
{
	NSDictionary* parameters = @{
								 @"after":@(comment.ID),//[comment.updateTime stringWithFormat:@"yyyyMMddHHmmssFFF"],
								 @"count":@(count),
								 @"linkhash":linkhash,
								 };
	return [self commentsByParameters:parameters error:error];
}

@end
