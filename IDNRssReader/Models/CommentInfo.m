//
//  CommentInfo.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentInfo.h"
#import "NSString+IDNExtend.h"
#import "IDNFoundation.h"

@implementation CommentInfo

- (void)setLinkHashWithUrl:(NSString*)url //linkHash = md5(url)
{
	_linkHash = [url md5];
}

- (instancetype)initWithInfoDict:(NSDictionary*)dicInfo;
{
	self = [super init];
	if(self)
	{
		self.ID = [dicInfo[@"id"] intValue];
		self.parentID = [dicInfo[@"parent_id"] intValue];
		self.userID = [dicInfo[@"user_id"] intValue];
		self.name = dicInfo[@"name"];
		self.email = dicInfo[@"email"];
		self.linkHash = dicInfo[@"link_hash"];
		self.content = dicInfo[@"content"];
		self.updateTime = [NSDate dateFromString:dicInfo[@"updated_at"] format:@"yyyy-MM-dd HH:mm:ss"];
	}
	return self;
}

- (NSMutableDictionary*)infoDictOfSubmission; //提交信息
{
	NSMutableDictionary* dicInfo = [NSMutableDictionary dictionary];
	if(self.parentID)
		dicInfo[@"parent_id"] = @(self.parentID);
	if(self.userID)
		dicInfo[@"user_id"] = @(self.userID);
	if(self.name)
		dicInfo[@"name"] = self.name;
	if(self.email)
		dicInfo[@"email"] = self.email;
	dicInfo[@"link_hash"] = self.linkHash;
	dicInfo[@"content"] = self.content;
	return dicInfo;
}

- (NSComparisonResult)compare:(CommentInfo*)comment
{
	return [comment.updateTime compare:self.updateTime];
}

@end
