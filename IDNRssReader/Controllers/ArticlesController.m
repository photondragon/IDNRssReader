//
//  ArticlesController.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/17.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "ArticlesController.h"
#import "IDNFeedParser.h"
#import "UIViewController+IDNPrompt.h"
#import "IDNRefreshControl.h"
#import "WebViewController.h"
#import "IDNAsyncTask.h"

@interface ArticlesController ()

@property(nonatomic,strong) NSArray* articles;
@property(nonatomic) BOOL firstLoad;
@property(nonatomic) BOOL loading;

@end

@implementation ArticlesController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout = 0;

	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

	[self.tableView.topRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

	self.firstLoad = YES;
	[self refresh:nil];
}

- (void)refresh:(id)sender
{
	if(self.loading)
		return;

	self.loading = YES;
	if(self.firstLoad)
	{
		[self.navigationController prompting:@"正在加载"];
		self.firstLoad = NO;
	}
	else
		self.tableView.topRefreshControl.refreshing = YES;

	__weak ArticlesController* weakself = self;
	[IDNAsyncTask putTaskWithKey:@"articles" group:nil task:^id{
		if([IDNAsyncTask isTaskCancelled])
			return nil;
		NSArray* articles  = [IDNFeedParser feedItemsWithUrl:@"http://news.163.com/special/00011K6L/rss_newstop.xml"];
		if(articles==nil)
		{
			NSDictionary* errorInfo = @{NSLocalizedDescriptionKey:@"解析失败"};
			return [NSError errorWithDomain:@"IDNRssReader" code:0 userInfo:errorInfo];
		}
		return articles;
	} finished:^(id obj) {
		ArticlesController* strongself = weakself;
		if([obj isKindOfClass:[NSError class]])
		{
			[strongself.navigationController prompt:[NSString stringWithFormat:@"获取文章列表失败\n%@", [obj localizedDescription]] duration:2];
		}
		else
		{
			strongself.articles = obj;
			[strongself.navigationController stopPrompt];
		}
		strongself.tableView.topRefreshControl.refreshing = NO;
		strongself.loading = NO;
	} cancelled:^{
		ArticlesController* strongself = weakself;
		[strongself.navigationController stopPrompt];
		strongself.tableView.topRefreshControl.refreshing = NO;
		strongself.loading = NO;
	}];

//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		NSArray* articles  = [IDNFeedParser feedItemsWithUrl:@"http://news.163.com/special/00011K6L/rss_newstop.xml"];
//
//		dispatch_async(dispatch_get_main_queue(), ^{
//			ArticlesController* strongself = weakself;
//			strongself.articles = articles;
//			[strongself.navigationController stopPrompt];
//			strongself.tableView.topRefreshControl.refreshing = NO;
//			strongself.loading = NO;
//		});
//	});
}

- (void)setArticles:(NSArray *)articles
{
	_articles = articles;
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
	MWFeedItem* article = self.articles[indexPath.row];
	cell.textLabel.text = article.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	MWFeedItem* article = self.articles[indexPath.row];

	WebViewController* c = [[WebViewController alloc] init];
	c.url = article.link;
	[self.navigationController pushViewController:c animated:YES];
}

@end
