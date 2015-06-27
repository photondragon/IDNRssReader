//
//  ArticleInfoController.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "ArticleInfoController.h"
#import "IDNKit.h"
#import "CommentsController.h"
#import "IDNFoundation.h"
#import "UMSocial.h"
#import "RRConstant.h"

@interface ArticleInfoController ()
<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong) NSString* url;

@end

@implementation ArticleInfoController

- (void)dealloc
{
//	NSLog(@"%s", __func__);
	self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout	= 0;
}

- (void)setFeedItem:(IDNFeedItem *)feedItem
{
	_feedItem = feedItem;
	self.url = feedItem.link;
}

- (void)setUrl:(NSString *)url
{
	_url = url;

	[self view];

	if(url)
	{
		NSURL* nsurl = [NSURL URLWithString:url];
		NSURLRequest* request = [NSURLRequest requestWithURL:nsurl];
		[self.webView loadRequest:request];
	}
	else
		[self.webView loadRequest:nil];
}

#pragma mark Actions

- (IBAction)share:(id)sender {
	if(self.url==nil)
		return;

	[UMSocialData defaultData].extConfig.wechatSessionData.url = self.feedItem.link; //设置点击图片后跳转的地址（微信好友）
	[UMSocialData defaultData].extConfig.wechatTimelineData.url = self.feedItem.link; //设置点击图片后跳转的地址（微信朋友圈）

	[UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
	[UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";

	[UMSocialSnsService presentSnsIconSheetView:self
										 appKey:UMengAppKey
									  shareText:[NSString stringWithFormat:@"%@\n%@", self.feedItem.title,self.url]
									 shareImage:nil//[UIImage imageNamed:@"test.jpg"]
								shareToSnsNames:@[UMShareToWechatTimeline,UMShareToSina,UMShareToWechatSession,UMShareToTencent]
									   delegate:nil];
}

- (IBAction)comment:(id)sender {
	CommentsController* c = [[CommentsController alloc] init];
	c.linkhash = [self.url md5];
	[self.navigationController pushViewController:c animated:YES];
}

- (IBAction)favorite:(id)sender {
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//	[self prompting:@"正在加载"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//	NSLog(@"%s", __func__);
//	[self stopPrompt];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//	[self prompt:[NSString stringWithFormat:@"加载失败\n%@", error.localizedDescription] duration:2];
}
@end
