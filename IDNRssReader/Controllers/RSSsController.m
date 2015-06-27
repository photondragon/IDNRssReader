//
//  RSSsController.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/24.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "RSSsController.h"
#import "MyModels.h"
#import "IDNFeedParser.h"
#import "ArticlesController.h"
#import "UIViewController+IDNPrompt.h"
#import "IDNAsyncTask.h"
#import "LoginController.h"
#import "UIView+IDNKeyboard.h"

@interface RSSsController ()
<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UIBarButtonItem* btnAdd;
@property(nonatomic,strong) UIBarButtonItem* btnSubmit;

@property(nonatomic,strong) UIControl* maskView;

@property(nonatomic,strong) UIView* titleViewAddRss;
@property(nonatomic,strong) UITextField* textFieldRssUrl;
@property(nonatomic) BOOL submitting;

@end

@implementation RSSsController

- (void)loadView
{
	self.title = @"订阅";

	_textFieldRssUrl = [[UITextField alloc] initWithFrame:CGRectMake(8, 6, 2032, 32)];
	_textFieldRssUrl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_textFieldRssUrl.borderStyle = UITextBorderStyleRoundedRect;
	_textFieldRssUrl.autocorrectionType = UITextAutocorrectionTypeNo;
	_textFieldRssUrl.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_textFieldRssUrl.keyboardType = UIKeyboardTypeURL;

	_titleViewAddRss = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 44)];
	[_titleViewAddRss addSubview:_textFieldRssUrl];

	_btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(btnAddClicked:)];
	_btnSubmit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnSubmitClicked:)];

	self.navigationItem.rightBarButtonItem = _btnAdd;

	_tableView = [[UITableView alloc] init];
	if([_tableView respondsToSelector:@selector(setSeparatorInset:)])
		_tableView.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	_maskView = [[UIControl alloc] init];
	_maskView.hidden = YES;
	_maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
	_maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[_maskView addTarget:self action:@selector(maskViewClicked:) forControlEvents:UIControlEventTouchUpInside];

	UIView* contentView = [[UIView alloc] init];
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[contentView addSubview:_tableView];
	[contentView addSubview:_maskView];

	UIView* view = [[UIView alloc] init];
	[view addSubview:contentView];

	self.contentView = contentView;
	self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	__weak RSSsController* wself = self;

	self.view.keyboardFrameWillChangeBlock = ^(CGFloat bottomDistance, double animationDuration, UIViewAnimationCurve animationCurve){
		RSSsController* sself = wself;

		CGRect rect = sself.view.bounds;
		rect.size.height -= bottomDistance;
		[UIView animateWithDuration:animationDuration animations:^{
			sself.contentView.frame = rect;
		}];
	};

	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(onLogin:)];

	[self.navigationController prompting:@"正在读取RSS源信息"];
	[self preAddURL:@"http://news.163.com/special/00011K6L/rss_newstop.xml"];
	[self preAddURL:@"http://news.baidu.com/n?cmd=1&class=civilnews&tn=rss"];
	[self preAddURL:@"http://www.zhihu.com/rss"];
}

- (void)preAddURL:(NSString*)feedUrl
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		IDNFeedInfo* info = [IDNFeedParser feedInfoWithUrl:feedUrl];

		if(info==nil) //失败
			;//[self.navigationController prompt:@"读取RSS源信息失败" duration:2];
		else //成功
		{
			[self.navigationController stopPrompt];

			// 解析完成后在主线程更新显示
			dispatch_async(dispatch_get_main_queue(), ^{
				[self addFeedInfo:info];
			});
		}
	});
}

- (void)addFeedInfo:(IDNFeedInfo*)feedInfo
{
	[[MyModels rssManager] addRssInfo:feedInfo];
	[self.tableView reloadData];
}

- (void)onLogin:(id)sender
{
	LoginController* c = [LoginController new];
	[self.navigationController pushViewController:c animated:YES];
}

- (void)setSubmitting:(BOOL)submitting
{
	_submitting = submitting;
	if(submitting)
	{
		self.btnAdd.enabled = NO;
	}
	else
		self.btnAdd.enabled = YES;
}

- (void)maskViewClicked:(id)sender
{
	self.editing = NO;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	if(editing)
	{
		self.navigationItem.rightBarButtonItem = self.btnSubmit;
		self.navigationItem.titleView = self.titleViewAddRss;
		[self.textFieldRssUrl becomeFirstResponder];
		self.maskView.hidden = NO;
	}
	else{
		self.navigationItem.titleView = nil;
		self.navigationItem.rightBarButtonItem = self.btnAdd;
		self.maskView.hidden = YES;
	}
}

- (void)btnAddClicked:(id)sender
{
	self.editing = YES;
}

- (void)btnSubmitClicked:(id)sender
{
	NSString* url = self.textFieldRssUrl.text;
	[self submitRssUrl2:url];

	self.editing = NO;
}

- (void)submitRssUrl:(NSString*)rssUrl
{
	if(rssUrl.length==0)
		return;

	if(self.submitting)
		return;

	self.submitting = YES;
	[self prompting:@"正在获取订阅信息"];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		IDNFeedInfo* info = [IDNFeedParser feedInfoWithUrl:rssUrl];

		dispatch_async(dispatch_get_main_queue(), ^{
			self.submitting = NO;
			if(info==nil)
			{
				[self prompt:@"获取订阅信息失败" duration:2];
			}
			else
			{
				if([[MyModels rssManager] addRssInfo:info]==FALSE)
					[self prompt:@"订阅信息已存在" duration:2];
				else{
					self.textFieldRssUrl.text = nil;
					[self.tableView reloadData];
					[self stopPrompt];
				}
			}
		});
	});
}

- (void)submitRssUrl2:(NSString*)rssUrl
{
	if(rssUrl.length==0)
		return;

	if(self.submitting)
		return;

	self.submitting = YES;
	[self prompting:@"正在获取订阅信息"];
	[IDNAsyncTask putTaskWithKey:rssUrl group:nil task:^id{
		IDNFeedInfo* info = [IDNFeedParser feedInfoWithUrl:rssUrl];
		return info;
	} finished:^(id obj) {
		self.submitting = NO;
		if(obj==nil)
		{
			[self prompt:@"获取订阅信息失败" duration:2];
		}
		else
		{
			if([[MyModels rssManager] addRssInfo:(IDNFeedInfo*)obj]==FALSE)
				[self prompt:@"订阅信息已存在" duration:2];
			else{
				self.textFieldRssUrl.text = nil;
				[self.tableView reloadData];
				[self stopPrompt];
			}
		}
	} cancelled:^{
		self.submitting = NO;
		[self prompt:@"操作取消" duration:2];
	}];
}

#pragma mark Table View Datasource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [MyModels rssManager].list.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
	if(cell==nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];

		if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
			cell.preservesSuperviewLayoutMargins = NO;
		if([cell respondsToSelector:@selector(setLayoutMargins:)])
			cell.layoutMargins = UIEdgeInsetsZero;
		if([cell respondsToSelector:@selector(setSeparatorInset:)])
			cell.separatorInset = UIEdgeInsetsZero;
	}

	IDNFeedInfo* info = [MyModels rssManager].list[indexPath.row];
	cell.textLabel.text = info.title;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ArticlesController* c = [[ArticlesController alloc] init];
	[self.navigationController pushViewController:c animated:YES];
	IDNFeedInfo* info = [MyModels rssManager].list[indexPath.row];
	c.rssInfo = info;
}

@end
