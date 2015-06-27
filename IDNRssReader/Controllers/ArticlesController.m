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
#import "ArticleInfoController.h"
#import "IDNAsyncTask.h"
#import "JXBAdPageView.h"
#import "UIImageView+WebCache.h"

@interface ArticlesController ()
<UITableViewDataSource,
UITableViewDelegate,
JXBAdPageViewDelegate>

@property(nonatomic,strong) UITableView* tableView;

@property(nonatomic,strong) NSArray* articles;
@property(nonatomic) BOOL firstLoad;
@property(nonatomic) BOOL loading;

@property(nonatomic,strong) JXBAdPageView* imagesView;
@property(nonatomic,strong) NSArray* images;

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

	CGSize imagesViewSize;
	imagesViewSize.width = [UIScreen mainScreen].bounds.size.width;
	imagesViewSize.height = round(imagesViewSize.width/16.0*9.0);
	_imagesView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 0, imagesViewSize.width, imagesViewSize.height)];
	_imagesView.bWebImage = YES;
	_imagesView.delegate = self;

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
			NSMutableArray* images = [NSMutableArray new];
			for (IDNFeedItem* item in (NSArray*)obj) {
				if(item.image)
				{
					[images addObject:item.image];
					if(images.count>=10)
						break;
				}
			}
			if(images.count)
				strongself.images = images;
			else
				strongself.images = nil;

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

- (void)imageClickedAtIndex:(NSInteger)index
{
	if(index<0 || index>=self.images.count)
		return;
	NSString* imgUrl = self.images[index];
	IDNFeedItem* article = nil;
	for (IDNFeedItem* item in self.articles) {
		if([item.image isEqualToString:imgUrl])
		{
			article = item;
			break;
		}
	}

	ArticleInfoController* c = [[ArticleInfoController alloc] init];
	c.feedItem = article;
	[self.navigationController pushViewController:c animated:YES];
}

- (void)setArticles:(NSArray *)articles
{
	_articles = articles;
	[self.tableView reloadData];
}

- (void)setImages:(NSArray *)images
{
	_images = images;
	if(images.count==0)
	{
		self.tableView.tableHeaderView = nil;
		[self.imagesView startAdsWithBlock:nil block:nil];
	}
	else
	{
		self.tableView.tableHeaderView = self.imagesView;
		__weak ArticlesController* wself = self;
		[self.imagesView startAdsWithBlock:images block:^(NSInteger clickIndex) {
			ArticlesController* sself = wself;
			[sself imageClickedAtIndex:clickIndex];
		}];
	}
}

- (void)setRssInfo:(IDNFeedInfo *)rssInfo
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
    
	IDNFeedItem* article = self.articles[indexPath.row];
	cell.textLabel.text = article.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	IDNFeedItem* article = self.articles[indexPath.row];

	ArticleInfoController* c = [[ArticleInfoController alloc] init];
	c.feedItem = article;
	[self.navigationController pushViewController:c animated:YES];
}

#pragma mark JXBAdPageViewDelegate

- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl
{
//	imgView.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
	static UIImage* placeholder = nil;
	if(placeholder==nil)
		placeholder = [UIImage imageNamed:@"imageLoadFail.jpg"];
	[imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:placeholder];
}

@end
