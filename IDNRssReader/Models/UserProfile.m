//
//  UserProfile.m
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "UserProfile.h"
#import "IDNFoundation.h"

@implementation UserProfile

- (instancetype)initWithInfoDict:(NSDictionary*)dicInfo;
{
	self = [super init];
	if(self)
	{
		self.ID = [dicInfo[@"id"] intValue];
		self.nickname = dicInfo[@"nick_name"];
		self.talk = dicInfo[@"talk"];
		self.imageUrl = dicInfo[@"image"];
		self.updateTime = [NSDate dateFromString:dicInfo[@"updated_at"] format:@"yyyy-MM-dd HH:mm:ss"];
	}
	return self;
}

- (NSMutableDictionary*)infoDictOfSubmission; //提交信息
{
	NSMutableDictionary* dicInfo = [NSMutableDictionary dictionary];
	dicInfo[@"id"] = @(self.ID);
	if(self.nickname)
		dicInfo[@"nick_name"] = self.nickname;
	if(self.talk)
		dicInfo[@"talk"] = self.talk;
	if(self.imageUrl)
		dicInfo[@"image"] = self.imageUrl;
	return dicInfo;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	if(self)
	{
		self.ID = [aDecoder decodeIntForKey:@"ID"];
		self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
		self.talk = [aDecoder decodeObjectForKey:@"talk"];
		self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
		self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:self.ID forKey:@"ID"];
	[aCoder encodeObject:self.nickname forKey:@"nickname"];
	[aCoder encodeObject:self.talk forKey:@"talk"];
	[aCoder encodeObject:self.imageUrl forKey:@"imageUrl"];
	[aCoder encodeObject:self.updateTime forKey:@"updateTime"];
}

@end
