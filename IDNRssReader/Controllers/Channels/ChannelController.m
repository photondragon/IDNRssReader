//
//  ChannelController.m
//  IDNRssReader
//
//  Created by photondragon on 15/7/6.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "ChannelController.h"
#import "RssManage.h"
#import "IDNAsyncTask.h"
#import "UIViewController+IDNPrompt.h"

@interface ChannelController ()

@property(nonatomic) BOOL needsLoadRss;
@property(nonatomic) BOOL isViewLoaded;

@end

@implementation ChannelController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.isViewLoaded = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self loadRssIfNeed];
}

- (void)loadRssIfNeed
{
	if(self.needsLoadRss==NO)
		return;
	self.needsLoadRss = NO;

	[self prompting:@"正在加载"];
	__weak ChannelController* wself = self;
	[IDNAsyncTask putTask:^id{
		IDNFeedInfo* feedInfo = [RssManage feedInfoWithUrl:_rssUrl];
		return feedInfo;
	} finished:^(id obj) {
		ChannelController* sself = wself;
		if(obj==nil)
			[sself prompt:@"获取新闻失败" duration:2];
		else
		{
			[self stopPrompt];
			sself.rssInfo = (IDNFeedInfo*)obj;
		}
	} cancelled:^{
		ChannelController* sself = wself;
		[sself prompt:@"操作取消" duration:2];
	}];
}
- (void)setRssUrl:(NSString *)rssUrl
{
	_rssUrl = rssUrl;

	self.needsLoadRss = YES;
	if(self.isViewLoaded)
		[self loadRssIfNeed];
}

@end
