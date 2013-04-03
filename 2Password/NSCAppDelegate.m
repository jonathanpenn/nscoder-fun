//
//  NSCAppDelegate.m
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import "NSCAppDelegate.h"
#import "NSCPasswordDocument.h"
#import "NSCLoginViewController.h"

@interface NSCAppDelegate ()

@property (nonatomic, strong) NSCPasswordDocument *document;

@end

@implementation NSCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentLoginViewController];
    });
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self presentLoginViewController];
}

- (void)presentLoginViewController
{
    NSCLoginViewController *controller = [NSCLoginViewController controllerFromStoryboard:self.window.rootViewController.storyboard];
    [self.window.rootViewController presentViewController:controller animated:NO completion:nil];
}



















@end
