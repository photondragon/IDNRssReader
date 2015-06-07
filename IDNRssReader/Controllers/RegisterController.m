//
//  RegisterController.m
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "RegisterController.h"
#import "IDNFrameView.h"
#import "MyModels.h"
#import "IDNKit.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewUserName;
@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewEmail;
@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewPassword;
@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewPassword2;
@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewNickname;

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNickname;

@property(nonatomic) BOOL submitting;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout = 0;

	self.frameViewUserName.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;
	self.frameViewEmail.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;
	self.frameViewPassword.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;
	self.frameViewPassword2.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;
	self.frameViewNickname.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(btnSubmitClicked:)];
}

- (void)setSubmitting:(BOOL)loginning
{
	if(_submitting==loginning)
		return;
	_submitting = loginning;
	if(loginning)
	{
		self.navigationItem.hidesBackButton = YES;
	}
	else
	{
		self.navigationItem.hidesBackButton = NO;
	}
}

- (BOOL)verifyInput
{
	if(self.textFieldUserName.text.length==0)
	{
		[self prompt:@"用户名不可为空" duration:2];
		return NO;
	}
	if(self.textFieldEmail.text.length==0)
	{
		[self prompt:@"Email不可为空" duration:2];
		return NO;
	}
	if(self.textFieldPassword.text.length==0)
	{
		[self prompt:@"密码不可为空" duration:2];
		return NO;
	}
	if([self.textFieldPassword.text isEqualToString:_textFieldPassword2.text]==NO)
	{
		[self prompt:@"密码输入不一致" duration:2];
		return NO;
	}
	return YES;
}

- (IBAction)btnSubmitClicked:(id)sender {
	if([self verifyInput]==NO)
		return;

	if(self.submitting)
		return;

	[self prompting:@"正在注册"];
	self.submitting = YES;

	NSMutableDictionary* info = [NSMutableDictionary dictionary];

	info[@"name"] = _textFieldUserName.text;
	info[@"email"] = _textFieldEmail.text;
	info[@"password"] = _textFieldPassword.text;
	if(_textFieldNickname.text.length)
		info[@"nick_name"] = _textFieldNickname.text;

	__weak RegisterController* wself = self;
	[MyModels registerWithInfo:info finished:^(NSError *error) {
		RegisterController* sself = wself;

		sself.submitting = NO;

		if(error)
		{
			[sself prompt:[NSString stringWithFormat:@"注册失败\n%@", error.localizedDescription] duration:2];
		}
		else
		{
			[sself prompt:@"注册成功" duration:1 blockTouches:YES finishedHandle:^{
				[sself.navigationController setViewControllers:@[self.navigationController.viewControllers[0]] animated:YES];
			}];
		}
	}];
}

@end
