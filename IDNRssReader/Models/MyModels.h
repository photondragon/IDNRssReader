//
//  MyModels.h
//  Contacts
//
//  Created by photondragon on 15/4/12.
//  Copyright (c) 2015年 no. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssManage.h"
#import "UserProfile.h"

@interface MyModels : NSObject

+ (RssManage*)rssManager;
+ (UserProfile*)currentUser;
+ (void)save;

+ (void)loginWithUser:(NSString*)user password:(NSString*)password finished:(void (^)(NSError*error))finishedBlock;
+ (void)registerWithInfo:(NSDictionary*)info finished:(void (^)(NSError*error))finishedBlock;
+ (void)logout;

@end
