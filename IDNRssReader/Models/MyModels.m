//
//  MyModels.m
//  Contacts
//
//  Created by photondragon on 15/4/12.
//  Copyright (c) 2015年 no. All rights reserved.
//

#import "MyModels.h"
#import "NSString+IDNExtend.h"
#import "IDNFoundation.h"
#import "IDNAsyncTask.h"
#import "UserServer.h"

static UserProfile* currentUser = nil;

@implementation MyModels

+ (void)initialize
{
	currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[NSString documentsPathWithFileName:@"currentUser"]];
}

+ (RssManage*)rssManager
{
	static RssManage* rssManager = nil; //这句赋值代码只运行一次
	if(rssManager==nil)
	{
		rssManager = (RssManage*)[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString documentsPathWithFileName:@"rssInfos.dat"]];
		if(rssManager==nil)
			rssManager = [[RssManage alloc] init];
	}
	return rssManager;
}

+ (UserProfile*)currentUser
{
	return currentUser;
}

+ (void)save
{
	[NSKeyedArchiver archiveRootObject:[self rssManager] toFile:[NSString documentsPathWithFileName:@"rssInfos.dat"]];
}

+ (void)saveCurrentUser
{
	if(currentUser)
		[NSKeyedArchiver archiveRootObject:currentUser toFile:[NSString documentsPathWithFileName:@"currentUser"]];
	else
		[NSFileManager removeDocumentFile:@"currentUser"];
}

+ (void)registerWithInfo:(NSDictionary*)info finished:(void (^)(NSError*error))finishedBlock;
{
	if (info.count==0)
		@throw [NSError errorDescription:@"注册信息为空"];

	[IDNAsyncTask putTask:^id{
		NSError* error = nil;
		UserProfile* profile = [[UserServer server] registerUser:info error:&error];
		if(error)
			return error;
		return profile;
	} finished:^(id obj) {
		if([obj isKindOfClass:[NSError class]])
		{
			currentUser = nil;
			if(finishedBlock)
				finishedBlock((NSError*)obj);
		}
		else
		{
			currentUser = (UserProfile*)obj;
			if(finishedBlock)
				finishedBlock(nil);
		}
		[self saveCurrentUser];
	} cancelled:nil];
}

+ (void)loginWithUser:(NSString*)user password:(NSString*)password finished:(void (^)(NSError*error))finishedBlock
{
	user = [user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (user.length==0 || password.length==0)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			if(finishedBlock)
				finishedBlock([NSError errorDescription:@"用户名/密码不可为空"]);
		});
		return;
	}

	[IDNAsyncTask putTask:^id{
		NSError* error = nil;
		UserProfile* profile = [[UserServer server] loginUser:@{@"user" : user,
																@"password" : password}
														error:&error];
		if (error) {
			return error;
		}
		return profile;
	} finished:^(id obj) {
		if([obj isKindOfClass:[NSError class]])
		{
			currentUser = nil;
			if(finishedBlock)
				finishedBlock((NSError*)obj);
		}
		else
		{
			currentUser = (UserProfile*)obj;
			if(finishedBlock)
				finishedBlock(nil);
		}
		[self saveCurrentUser];
	} cancelled:nil];
}

+ (void)logout
{
	currentUser = nil;
}

@end
