//
//  IDNFeedParser.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/17.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "IDNFeedParser.h"

@interface IDNFeedParser(hidden)
<MWFeedParserDelegate>
@end

@implementation IDNFeedParser
{
	MWFeedParser* feedParser;
	MWFeedInfo* feedInfo;
	NSMutableArray* articles;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (MWFeedInfo*)feedInfoWithUrl:(NSString*)url
{
	NSURL *feedURL = [NSURL URLWithString:url];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeInfoOnly; //只解析频道信息
	[feedParser parse];
	return feedInfo;
}

- (NSArray*)feedItemsWithUrl:(NSString*)url
{
	articles = [NSMutableArray array];

	NSURL *feedURL = [NSURL URLWithString:url];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeItemsOnly; //只解析频道信息
	[feedParser parse];

	return [NSArray arrayWithArray:articles];
}

+ (MWFeedInfo*)feedInfoWithUrl:(NSString*)url
{
	IDNFeedParser* parser = [[IDNFeedParser alloc] init];
	return [parser feedInfoWithUrl:url];
}

+ (NSArray*)feedItemsWithUrl:(NSString*)url
{
	IDNFeedParser* parser = [[IDNFeedParser alloc] init];
	return [parser feedItemsWithUrl:url];
}

#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
//	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
//	NSLog(@"Parsed Feed Info: “%@”", info.title);
	feedInfo = info;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
//	NSLog(@"Parsed Feed Item: “%@”", item.title);
	[articles addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
//	NSLog(@"Finished Parsing%@", (parser.stopped ? @" (Stopped)" : @""));
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
//	NSLog(@"Finished Parsing With Error: %@", error);
}

@end
