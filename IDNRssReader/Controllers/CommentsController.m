//
//  CommentsController.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "CommentsController.h"
#import "CommentList.h"
#import "IDNRefreshControl.h"
#import "IDNKit.h"
#import "CommentServer.h"
#import "IDNAsyncTask.h"

@interface CommentsController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) CommentList* comments;
@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL isFirstLoad;

@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.edgesForExtendedLayout = 0;
	self.title = @"评论";

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(comment:)];

	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

	[self.tableView.topRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView.bottomRefreshControl addTarget:self action:@selector(more:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender
{
	if(self.loading)
		return;

	self.loading = YES;
	if(self.isFirstLoad)
	{
		[self prompting:@"正在刷新"];
		self.isFirstLoad = NO;
	}
	else
		self.tableView.topRefreshControl.refreshing = YES;

	__weak CommentsController* wself = self;
	[self.comments asyncRefreshWithFinishedBlock:^(NSError *error) {
		CommentsController* sself = wself;

		self.loading = NO;
		self.tableView.topRefreshControl.refreshing = NO;

		if(error)
		{
			[sself prompt:[NSString stringWithFormat:@"刷新失败\n%@", error.localizedDescription] duration:2];
		}
		else
		{
			[sself stopPrompt];
		}
	}];
}

- (void)more:(id)sender
{
	if(self.loading)
		return;

	self.loading = YES;
	if(self.isFirstLoad)
	{
		[self prompting:@"正在加载"];
		self.isFirstLoad = NO;
	}
	else
		self.tableView.bottomRefreshControl.refreshing = YES;

	__weak CommentsController* wself = self;
	[self.comments asyncMoreWithFinishedBlock:^(NSError *error) {
		CommentsController* sself = wself;

		self.loading = NO;
		self.tableView.bottomRefreshControl.refreshing = NO;

		if(error)
		{
			[sself prompt:[NSString stringWithFormat:@"加载失败\n%@", error.localizedDescription] duration:2];
		}
		else
		{
			[sself stopPrompt];
		}
	}];
}

- (void)setLinkhash:(NSString *)linkhash
{
	_linkhash = linkhash;
	[self view];

	if(linkhash)
	{
		self.comments = [[CommentList alloc] init];
		self.comments.linkhash = linkhash;

		__weak CommentsController* wself = self;
		self.comments.listChangedBlock = ^(NSDictionary*deleted, NSDictionary*added, NSDictionary* modified){
			CommentsController* sself = wself;
			[sself.tableView reloadData];
		};
		self.isFirstLoad = YES;
		[self more:nil];
	}
	else
	{
		self.comments = nil;
	}
	[self.tableView reloadData];
}

- (void)comment:(id)sender
{
	if(self.loading)
		return;

	CommentInfo* comment = [[CommentInfo alloc] init];
	comment.content = [NSString stringWithFormat:@"comment at %@", [NSDate date]];
	comment.linkHash = self.linkhash;

	self.loading = YES;
	[self prompting:@"正在提交"];

	__weak CommentsController* wself = self;
	[IDNAsyncTask putTask:^id{
		NSError* error = nil;
		NSString* commentID = [[CommentServer server] createWithInfo:comment error:&error];
		if(commentID.length)
			return commentID;
		return error;
	} finished:^(id obj) {
		CommentsController* sself = wself;
		sself.loading = NO;

		if([obj isKindOfClass:[NSError class]])
		{
			[sself prompt:@"提交失败" duration:2];
		}
		else
		{
			sself.isFirstLoad = YES;
			[sself refresh:nil];
		}
	} cancelled:^{
		CommentsController* sself = wself;
		sself.loading = NO;
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.comments.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];

	CommentInfo* comment = self.comments.list[indexPath.row];
	cell.textLabel.text = comment.content;

	return cell;
}

@end
