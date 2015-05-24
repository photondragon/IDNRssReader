//
//  MyModels.m
//  Contacts
//
//  Created by photondragon on 15/4/12.
//  Copyright (c) 2015年 no. All rights reserved.
//

#import "MyModels.h"
#import "NSString+IDNExtend.h"

@implementation MyModels

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

+ (void)save
{
	[NSKeyedArchiver archiveRootObject:[self rssManager] toFile:[NSString documentsPathWithFileName:@"rssInfos.dat"]];
}

@end
