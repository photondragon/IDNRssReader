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

@interface ArticleInfoController ()
<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ArticleInfoController

- (void)dealloc
{
	self.webView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout	= 0;
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
	[self prompting:@"正在加载"];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self stopPrompt];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self prompt:[NSString stringWithFormat:@"加载失败\n%@", error.localizedDescription] duration:2];
}
@end
