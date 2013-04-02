//
//  NSCLoginViewController.m
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import "NSCLoginViewController.h"

@interface NSCLoginViewController ()

@end

@implementation NSCLoginViewController

+ (instancetype)controllerFromStoryboard:(UIStoryboard *)storyboard
{
    return [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (IBAction)closeButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
