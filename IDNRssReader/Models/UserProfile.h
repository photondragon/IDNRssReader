//
//  UserProfile.h
//  IDNRssReader
//
//  Created by photondragon on 15/6/7.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
<NSCoding>

@property(nonatomic) int ID;
@property(nonatomic) NSString* nickname;
@property(nonatomic) NSString* talk;
@property(nonatomic) NSString* imageUrl;
@property(nonatomic) NSDate* updateTime; //更新时间

- (instancetype)initWithInfoDict:(NSDictionary*)dicInfo;
- (NSMutableDictionary*)infoDictOfSubmission; //提交信息

@end
