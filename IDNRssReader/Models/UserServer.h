//
//  UserServer.h
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface UserServer : NSObject

+ (instancetype)server;

- (UserProfile*)registerUser:(NSDictionary*)registerInfo error:(NSError**)error;
- (UserProfile*)loginUser:(NSDictionary*)loginInfo error:(NSError**)error;

@end
