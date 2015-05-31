//
//  CommentInfo.h
//  IDNRssReader
//
//  Created by photondragon on 15/5/31.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property(nonatomic) int ID;
@property(nonatomic) int parentID;//父评论ID
@property(nonatomic) int userID;
@property(nonatomic) NSString* name;
@property(nonatomic) NSString* email;
@property(nonatomic) NSString* linkHash; //文章URL地址的MD5值
@property(nonatomic) NSString* content;
@property(nonatomic) NSDate* updateTime; //更新时间

- (instancetype)initWithInfoDict:(NSDictionary*)dicInfo;
- (void)setLinkHashWithUrl:(NSString*)url; //linkHash = md5(url)
- (NSMutableDictionary*)infoDictOfSubmission; //提交信息

- (NSComparisonResult)compare:(CommentInfo*)comment;

@end
