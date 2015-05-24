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
<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,strong) UITableView* tableView;

@property(nonatomic,strong) NSArray* articles;
@property(nonatomic) BOOL firstLoad;
@property(nonatomic) BOOL loading;

@end

@implementation ArticlesController

- (void)dealloc
{
	NSLog(@"%s", __func__);
}

- (void)loadView
{
	_tableView = [[UITableView alloc] init];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	UIView* view = [[UIView alloc] init];
	[view addSubview:_tableView];

	self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout = 0;

	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

	[self.tableView.topRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

	self.firstLoad = YES;
}

- (void)refresh:(id)sender
{
	NSString* url = self.rssInfo.url;
	if(url.length==0)
	{
		[self prompt:@"加载失败\n无效的URL地址" duration:2];
		return;
	}
	
	if(self.loading)
		return;

	self.loading = YES;
	if(self.firstLoad)
	{
		[self prompting:@"正在加载"];
		self.firstLoad = NO;
	}
	else
		self.tableView.topRefreshControl.refreshing = YES;

	__weak ArticlesController* weakself = self;
	[IDNAsyncTask putTaskWithKey:@"articles" group:nil task:^id{
		if([IDNAsyncTask isTaskCancelled])
			return nil;
		NSArray* articles  = [IDNFeedParser feedItemsWithUrl:url];
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
			[strongself prompt:[NSString stringWithFormat:@"获取文章列表失败\n%@", [obj localizedDescription]] duration:2];
		}
		else
		{
			strongself.articles = obj;
			[strongself stopPrompt];
		}
		strongself.tableView.topRefreshControl.refreshing = NO;
		strongself.loading = NO;
	} cancelled:^{
		ArticlesController* strongself = weakself;
		[strongself stopPrompt];
		strongself.tableView.topRefreshControl.refreshing = NO;
		strongself.loading = NO;
	}];
}

- (void)setArticles:(NSArray *)articles
{
	_articles = articles;
	[self.tableView reloadData];
}

- (void)setRssInfo:(RssInfo *)rssInfo
{
	[self view];
	_rssInfo = rssInfo;
	if(rssInfo==nil)
	{
		self.articles = nil;
	}
	else
	{
		self.title = rssInfo.title;
		[self refresh:nil];
	}
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
