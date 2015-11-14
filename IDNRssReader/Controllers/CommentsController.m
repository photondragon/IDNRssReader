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
#import "CommentCell.h"

@interface CommentsController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextViewDelegate,
IDNSegListObserver>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) CommentList* comments;
@property(nonatomic) BOOL loading;
@property(nonatomic) BOOL isFirstLoad;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContentBottom;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextView *textViewComment;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomBar;

@property(nonatomic,strong) CommentCell* calcCell; //用于根据文本计算大小

@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];

	__weak CommentsController* wself = self;

	self.view.keyboardFrameWillChangeBlock = ^(CGFloat bottomDistance, double animationDuration, UIViewAnimationCurve animationCurve){
		CommentsController* sself = wself;

		[UIView animateWithDuration:animationDuration animations:^{
			sself.constraintContentBottom.constant = bottomDistance;
		}];
	};

	self.edgesForExtendedLayout = 0;
	self.title = @"评论";

	self.tableView.estimatedRowHeight = 60;
	[self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];

	[self.tableView.topRefreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView.bottomRefreshControl addTarget:self action:@selector(more:) forControlEvents:UIControlEventValueChanged];

	self.textViewComment.layer.cornerRadius = 6;
	self.textViewComment.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
	self.textViewComment.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;

	self.bottomBar.layer.shadowRadius = 1.0;
	self.bottomBar.layer.shadowColor = [UIColor blackColor].CGColor;
//	self.bottomBar.layer.shadowOffset = CGSizeMake(0, 2);
	self.bottomBar.layer.shadowOpacity = 0.5;

	NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
	self.calcCell = nibViews[0];
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
	[self.comments refreshWithFinishedBlock:^(NSError *error) {
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
//		self.isFirstLoad = NO;
	}
	else
		self.tableView.bottomRefreshControl.refreshing = YES;

	__weak CommentsController* wself = self;
	[self.comments moreWithFinishedBlock:^(NSError *error) {
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

		[self.comments addSegListObserver:self];
		self.isFirstLoad = YES;
		[self more:nil];
	}
	else
	{
		self.comments = nil;
	}
	[self.tableView reloadData];
}

- (void)setLoading:(BOOL)loading
{
	if(_loading==loading)
		return;
	_loading = loading;
	if(loading)
	{
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}
	else
	{
		self.navigationItem.rightBarButtonItem.enabled = YES;
	}
}

- (IBAction)btnSubmitClicked:(id)sender {
	[self.textViewComment resignFirstResponder];

	if(self.textViewComment.text.length==0)
		return;

	if(self.loading)
		return;

	CommentInfo* comment = [[CommentInfo alloc] init];
	comment.content = self.textViewComment.text;
	comment.linkHash = self.linkhash;

	self.loading = YES;
	[self prompting:@"正在提交"];

	if(self.tableView.contentOffset.y > 0)
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

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
			self.textViewComment.text = nil;
			[self resizeTextView];
			[sself refresh:nil];
		}
	} cancelled:^{
		CommentsController* sself = wself;
		sself.loading = NO;
	}];
}

- (void)segList:(IDNSegList*)segList modifiedIndics:(NSArray*)modifiedIndics deletedIndics:(NSArray*)deletedIndics addedIndics:(NSArray*)addedIndics
{
	if(self.isFirstLoad)// 如果是首次刷新，重新加载数据
	{
		self.isFirstLoad = NO;
		[self.tableView reloadData];
	}
	else // 增量刷新
	{
		[_tableView refreshRowsModified:modifiedIndics deleted:deletedIndics added:addedIndics inSection:0];
	}
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.comments.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CommentInfo* comment = self.comments.list[indexPath.row];
	self.calcCell.comment = comment;

	CGSize newSize = [self.calcCell.labelComment sizeThatFits:CGSizeMake(self.tableView.bounds.size.width-16, 0)];

	return newSize.height+16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

	CommentInfo* comment = self.comments.list[indexPath.row];
	cell.comment = comment;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.textViewComment resignFirstResponder];
}

- (void)resizeTextView
{
	CGSize newSize = [self.textViewComment sizeThatFits:self.textViewComment.bounds.size];
	self.constraintTextViewHeight.constant = newSize.height;
}

#pragma mark UITextFieldDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[self btnSubmitClicked:nil];
		return NO;
	}
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self resizeTextView];
	});
	return YES;
}

@end
