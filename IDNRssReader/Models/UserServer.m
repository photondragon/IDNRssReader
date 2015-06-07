//
//  UserServer.m
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "UserServer.h"
#import "IDNNetwork.h"
#import "RRConstant.h"
#import "IDNFoundation.h"

@implementation UserServer

+ (instancetype)server
{
	static UserServer* server = nil;
	if(server==nil)
	{
		server = [[UserServer alloc] init];
	}
	return server;
}

- (NSString*)urlRegister
{
	return [NSString stringWithFormat:@"%@/api/users/register", RRHostName];
}
- (NSString*)urlLogin
{
	return [NSString stringWithFormat:@"%@/api/users/login", RRHostName];
}

- (UserProfile*)registerUser:(NSDictionary*)registerInfo error:(NSError**)error;
{
	NSDictionary* dicResponse = [IDNNetwork postToURL:[self urlRegister] parameters:registerInfo error:error];
	if(dicResponse==nil)
		return nil;
	int err = [dicResponse[@"errcode"] intValue];
	if(err==0)//成功
	{
		UserProfile* profile = [[UserProfile alloc] initWithInfoDict:dicResponse[@"data"][@"profile"]];
		if(error) *error = nil;
		return profile;
	}
	if(error) *error = [NSError errorWithDomain:RRErrorDomainServer description:dicResponse[@"errdesc"]];
	return nil;
}

- (UserProfile*)loginUser:(NSDictionary*)loginInfo error:(NSError**)error;
{
	NSDictionary* dicResponse = [IDNNetwork postToURL:[self urlLogin] parameters:loginInfo error:error];
	if(dicResponse==nil)
		return nil;
	int err = [dicResponse[@"errcode"] intValue];
	if(err==0)//成功
	{
		UserProfile* profile = [[UserProfile alloc] initWithInfoDict:dicResponse[@"data"][@"profile"]];
		if(error) *error = nil;
		return profile;
	}
	if(error) *error = [NSError errorWithDomain:RRErrorDomainServer description:dicResponse[@"errdesc"]];
	return nil;
}

@end
