//
//  RssManage.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/24.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDNFeedParser.h"

@interface RssManage : NSObject

@property(nonatomic,strong,readonly) NSArray* list;

- (IDNFeedInfo*)getRssInfoWithUrl:(NSString*)url;
- (BOOL)addRssInfo:(IDNFeedInfo*)rssInfo;
- (BOOL)delRssInfo:(IDNFeedInfo*)rssInfo;

+ (IDNFeedInfo*)uncachedFeedInfoWithUrl:(NSString*)url; // 直接从网络获取最新数据，并且缓存到本地
+ (IDNFeedInfo*)cachedFeedInfoWithUrl:(NSString*)url; // 只从缓存读取数据
+ (IDNFeedInfo*)feedInfoWithUrl:(NSString*)url; // 优先从缓存读取数据，没有再从网络获取最新数据，并且

+ (NSArray*)uncachedFeedItemsWithUrl:(NSString*)url; // 直接从网络获取最新数据，并且缓存到本地
+ (NSArray*)cachedFeedItemsWithUrl:(NSString*)url; // 只从缓存读取数据
+ (NSArray*)feedItemsWithUrl:(NSString*)url; // 优先从缓存读取数据，没有再从网络获取最新数据，并且缓存到本地

@end
