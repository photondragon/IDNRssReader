//
//  ChannelsController.m
//  IDNRssReader
//
//  Created by photondragon on 15/7/6.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "ChannelsController.h"
#import "ChannelController.h"

@interface ChannelsController ()

@end

@implementation ChannelsController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout = 0;

	self.title = @"焦点新闻";

	ChannelController* c1 = [ChannelController new];
	c1.title = @"国内";
	c1.rssUrl = @"http://news.baidu.com/n?cmd=1&class=civilnews&tn=rss";

	ChannelController* c2 = [ChannelController new];
	c2.title = @"国际";
	c2.rssUrl = @"http://news.baidu.com/n?cmd=1&class=internews&tn=rss";

	ChannelController* c3 = [ChannelController new];
	c3.title = @"军事";
	c3.rssUrl = @"http://news.baidu.com/n?cmd=1&class=mil&tn=rss";

	ChannelController* c4 = [ChannelController new];
	c4.title = @"财经";
	c4.rssUrl = @"http://news.baidu.com/n?cmd=1&class=finannews&tn=rss";

	ChannelController* c5 = [ChannelController new];
	c5.title = @"互联网";
	c5.rssUrl = @"http://news.baidu.com/n?cmd=1&class=internet&tn=rss";

	ChannelController* c6 = [ChannelController new];
	c6.title = @"房产";
	c6.rssUrl = @"http://news.baidu.com/n?cmd=1&class=housenews&tn=rss";

	ChannelController* c7 = [ChannelController new];
	c7.title = @"汽车";
	c7.rssUrl = @"http://news.baidu.com/n?cmd=1&class=autonews&tn=rss";

	ChannelController* c8 = [ChannelController new];
	c8.title = @"体育";
	c8.rssUrl = @"http://news.baidu.com/n?cmd=1&class=sportnews&tn=rss";

	ChannelController* c9 = [ChannelController new];
	c9.title = @"娱乐";
	c9.rssUrl = @"http://news.baidu.com/n?cmd=1&class=enternews&tn=rss";

	ChannelController* c10 = [ChannelController new];
	c10.title = @"游戏";
	c10.rssUrl = @"http://news.baidu.com/n?cmd=1&class=gamenews&tn=rss";

	ChannelController* c11 = [ChannelController new];
	c11.title = @"教育";
	c11.rssUrl = @"http://news.baidu.com/n?cmd=1&class=edunews&tn=rss";

	ChannelController* c12 = [ChannelController new];
	c12.title = @"女人";
	c12.rssUrl = @"http://news.baidu.com/n?cmd=1&class=healthnews&tn=rss";

	ChannelController* c13 = [ChannelController new];
	c13.title = @"科技";
	c13.rssUrl = @"http://news.baidu.com/n?cmd=1&class=technnews&tn=rss";

	ChannelController* c14 = [ChannelController new];
	c14.title = @"社会";
	c14.rssUrl = @"http://news.baidu.com/n?cmd=1&class=socianews&tn=rss";

//	ChannelController* c1 = [ChannelController new];
//	c1.title = @"";
//	c1.rssUrl = @"";

	self.viewControllers = @[c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
