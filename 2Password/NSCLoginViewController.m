//
//  NSCLoginViewController.m
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import "NSCLoginViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface NSCLoginViewController ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *motionQueue;

@end

@implementation NSCLoginViewController

+ (instancetype)controllerFromStoryboard:(UIStoryboard *)storyboard
{
    return [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.motionQueue = [[NSOperationQueue alloc] init];
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 0.2;
    
    if (!self.motionManager.isDeviceMotionAvailable) {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }

    [self.motionManager startDeviceMotionUpdatesToQueue:self.motionQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (motion.userAcceleration.x > 3 ||
            motion.userAcceleration.y > 3 ||
            motion.userAcceleration.z > 3) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.motionManager stopDeviceMotionUpdates];
}

@end
