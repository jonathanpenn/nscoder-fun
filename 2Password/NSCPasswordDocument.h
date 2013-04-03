//
//  NSCPasswordDocument.h
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCPassword : NSObject
<NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (instancetype)passwordWithUsername:(NSString *)username password:(NSString *)password;

@end

@interface NSCPasswordDocument : NSObject

@property (readonly, nonatomic, strong) NSArray *items;

- (void)addPassword:(NSCPassword *)password;
- (void)removePasswordAtIndex:(NSUInteger)index;

@end
