//
//  RssManage.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/24.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssInfo : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString* imageUrl;

@end

@interface RssManage : NSObject

@property(nonatomic,strong,readonly) NSArray* list;

- (RssInfo*)getRssInfoWithUrl:(NSString*)url;
- (BOOL)addRssInfo:(RssInfo*)rssInfo;
- (BOOL)delRssInfo:(RssInfo*)rssInfo;

@end
