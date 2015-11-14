//
//  ChannelController.h
//  IDNRssReader
//
//  Created by photondragon on 15/7/6.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "ArticlesController.h"

@interface ChannelController : ArticlesController

@property(nonatomic,strong) NSString* rssUrl;

@end
