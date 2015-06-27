//
//  RssManage.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/24.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "RssManage.h"

@implementation RssManage
{
	NSMutableArray* rssInfos;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		rssInfos = [[NSMutableArray alloc] init];
	}
	return self;
}

- (IDNFeedInfo*)getRssInfoWithUrl:(NSString*)url
{
	if(url.length==0)
		return nil;
	for (IDNFeedInfo* info in rssInfos) {
		if([info.url isEqualToString:url])
			return info;
	}
	return nil;
}

- (BOOL)addRssInfo:(IDNFeedInfo*)rssInfo
{
	if(rssInfo==nil || rssInfo.url.length==0)
		return FALSE;
	if([self getRssInfoWithUrl:rssInfo.url])
		return FALSE;
	[rssInfos addObject:rssInfo];
	return TRUE;
}

- (BOOL)delRssInfo:(IDNFeedInfo*)rssInfo
{
	if(rssInfo==nil || rssInfo.url.length==0)
		return FALSE;
	for (NSInteger i = 0; i<rssInfos.count; i++) {
		IDNFeedInfo* info = rssInfos[i];
		if([info.url isEqualToString:rssInfo.url])
		{
			[rssInfos removeObjectAtIndex:i];
			return TRUE;
		}
	}
	return FALSE;
}

- (NSArray*)list{
	return rssInfos;
}

@end
