//
//  LoginController.m
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "LoginController.h"
#import "IDNFrameView.h"
#import "MyModels.h"
#import "IDNKit.h"
#import "RegisterController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewUserName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet IDNFrameView *frameViewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property(nonatomic) BOOL loginning;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.edgesForExtendedLayout = 0;

	self.frameViewUserName.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;
	self.frameViewPassword.drawEdgeLines = DrawEdgeLineLeft | DrawEdgeLineRight | DrawEdgeLineTop | DrawEdgeLineBottom;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(onRegister:)];
}

- (void)onRegister:(id)sender
{
	RegisterController* c = [RegisterController new];
	[self.navigationController pushViewController:c animated:YES];
}

- (void)setLoginning:(BOOL)loginning
{
	if(_loginning==loginning)
		return;
	_loginning = loginning;
	if(loginning)
	{
		self.navigationItem.hidesBackButton = YES;
	}
	else
	{
		self.navigationItem.hidesBackButton = NO;
	}
}

- (IBAction)btnLoginClicked:(id)sender {
	if(self.loginning)
		return;

	[self prompting:@"正在登录"];
	self.loginning = YES;

	__weak LoginController* wself = self;
	[MyModels loginWithUser:self.textFieldUserName.text password:self.textFieldPassword.text finished:^(NSError *error) {
		LoginController* sself = wself;

		sself.loginning = NO;

		if(error)
		{
			[sself prompt:[NSString stringWithFormat:@"登录失败\n%@", error.localizedDescription] duration:2];
		}
		else
		{
			[sself prompt:@"登录成功" duration:1 blockTouches:YES finishedHandle:^{
				[sself.navigationController popViewControllerAnimated:YES];
			}];
		}
	}];
}

@end
