//
//  ArticleInfoController.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDNFeedParser.h"

@interface ArticleInfoController : UIViewController

@property(nonatomic,strong) IDNFeedItem* feedItem;

@end
