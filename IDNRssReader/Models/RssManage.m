//
//  RssManage.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/24.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "RssManage.h"
#import "IDNFeedParser.h"
#import "IDNFileCache.h"

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

+ (NSArray*)cachedFeedItemsWithUrl:(NSString*)url
{
	NSData* data = [[IDNFileCache sharedCache] dataWithKey:url];
	if(data==nil)
		return nil;
	return [IDNFeedParser feedItemsWithData:data fromUrl:url];
}
+ (NSArray*)uncachedFeedItemsWithUrl:(NSString*)url
{
	NSData* rssData = [IDNFeedParser dataFromUrl:url];
	if(rssData==nil)
		return nil;

	// 获取文章列表
	NSArray* items = [IDNFeedParser feedItemsWithData:rssData fromUrl:url];
	if(items==nil)
		return nil;

	[[IDNFileCache sharedCache] cacheFileWithData:rssData forKey:url];

	return items;
}

+ (NSArray*)feedItemsWithUrl:(NSString*)url
{
	NSData* rssData = [[IDNFileCache sharedCache] dataWithKey:url cacheAge:300];

	BOOL isFromCache;
	if(rssData==nil)//缓存中没有
	{
		isFromCache = NO;
		rssData = [IDNFeedParser dataFromUrl:url];
		if(rssData==nil)
			return nil;
	}
	else
		isFromCache = YES;
	
	// 获取文章列表
	NSArray* items = [IDNFeedParser feedItemsWithData:rssData fromUrl:url];
	if(items==nil)
		return nil;

	if(isFromCache==NO)
		[[IDNFileCache sharedCache] cacheFileWithData:rssData forKey:url];

	return items;
}

+ (IDNFeedInfo*)cachedFeedInfoWithUrl:(NSString*)url
{
	NSData* data = [[IDNFileCache sharedCache] dataWithKey:url];
	if(data==nil)
		return nil;
	return [IDNFeedParser feedInfoWithData:data fromUrl:url];
}
+ (IDNFeedInfo*)uncachedFeedInfoWithUrl:(NSString*)url
{
	NSData* rssData = [IDNFeedParser dataFromUrl:url];
	if(rssData==nil)
		return nil;

	// 获取文章列表
	IDNFeedInfo* info = [IDNFeedParser feedInfoWithData:rssData fromUrl:url];
	if(info==nil)
		return nil;

	[[IDNFileCache sharedCache] cacheFileWithData:rssData forKey:url];

	return info;
}

+ (IDNFeedInfo*)feedInfoWithUrl:(NSString*)url
{
	NSData* rssData = [[IDNFileCache sharedCache] dataWithKey:url cacheAge:300];

	BOOL isFromCache;
	if(rssData==nil)//缓存中没有
	{
		isFromCache = NO;
		rssData = [IDNFeedParser dataFromUrl:url];
		if(rssData==nil)
			return nil;
	}
	else
		isFromCache = YES;

	// 获取文章列表
	IDNFeedInfo* info = [IDNFeedParser feedInfoWithData:rssData fromUrl:url];
	if(info==nil)
		return nil;

	if(isFromCache==NO)
		[[IDNFileCache sharedCache] cacheFileWithData:rssData forKey:url];

	return info;
}

@end
