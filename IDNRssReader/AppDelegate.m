//
//  AppDelegate.m
//  IDNRssReader
//
//  Created by photondragon on 15/5/17.
//  Copyright (c) 2015年 iosdev.net. All rights reserved.
//

#import "AppDelegate.h"
#import "RSSsController.h"
#import "IDNFoundation.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "RRConstant.h"
#import "ChannelsController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[UMSocialData setAppKey:UMengAppKey];
	[UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];

	NSLog(@"%@", [NSString documentsPath]);
	
	CGRect rect = [UIScreen mainScreen].bounds;
	self.window = [[UIWindow alloc] initWithFrame:rect];
	self.window.backgroundColor = [UIColor whiteColor];

	RSSsController* c = [[RSSsController alloc] init];

	UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:c];
	nav.tabBarItem.title = @"订阅";

	ChannelsController* channels = [ChannelsController new];
	UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:channels];
	nav2.tabBarItem.title = @"频道";

	UINavigationController* nav3 = [UINavigationController new];
	nav3.tabBarItem.title = @"我的";

	UITabBarController* tab = [[UITabBarController alloc] init];
	tab.viewControllers = @[nav,nav2,nav3];
	self.window.rootViewController = tab;

	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation
{
	return  [UMSocialSnsService handleOpenURL:url];
}
@end
