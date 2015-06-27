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

@end
