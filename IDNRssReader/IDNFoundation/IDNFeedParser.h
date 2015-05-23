//
//  IDNFeedParser.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/17.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

// Rss解析器
@interface IDNFeedParser : NSObject

+ (MWFeedInfo*)feedInfoWithUrl:(NSString*)url;
+ (NSArray*)feedItemsWithUrl:(NSString*)url; // 返回MWFeedItem对象的数组

@end
