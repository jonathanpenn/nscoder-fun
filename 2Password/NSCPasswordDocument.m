//
//  NSCPasswordDocument.m
//  2Password
//
//  Created by Jonathan on 4/2/13.
//  Copyright (c) 2013 NSCoder Cleveland. All rights reserved.
//

#import "NSCPasswordDocument.h"
#import <Security/Security.h>

@interface NSCPasswordDocument ()

@property (nonatomic, strong) NSMutableArray *passwords;

@end

@implementation NSCPasswordDocument

- (NSArray *)items
{
    return self.passwords;
}

- (NSMutableArray *)passwords
{
    if (!_passwords) {
        NSDictionary *dict = @{
           (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
           (__bridge id)kSecAttrService: @"our.app.stuff",
           (__bridge id)kSecAttrAccount: @"ourPasswords",
           (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue,
           (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
        };

        CFDataRef refData;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict, (CFTypeRef *)&refData);
        NSData *passDat = (__bridge_transfer NSData *)refData;

        if (passDat == nil) {
            _passwords = [NSMutableArray array];
        } else {
            _passwords = [NSKeyedUnarchiver unarchiveObjectWithData:passDat];
        }

        if (status != 0) {
            NSLog(@"Houston we have a problem: %ld", status);
        }
    }

    return _passwords;
}

- (void)writePasswords
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passwords];

    NSDictionary *dict = @{
       (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
       (__bridge id)kSecAttrService: @"our.app.stuff",
       (__bridge id)kSecAttrAccount: @"ourPasswords",
       (__bridge id)kSecValueData: data,
       (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
    };

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);

    if (status != 0) {
        NSLog(@"Houston we have a problem: %ld", status);
    }
}

- (void)addPassword:(NSCPassword *)password
{
    [self.passwords addObject:password];
    [self writePasswords];
}

- (void)removePasswordAtIndex:(NSUInteger)index
{
    [self.passwords removeObjectAtIndex:index];
    [self writePasswords];
}

@end


@implementation NSCPassword

+ (instancetype)passwordWithUsername:(NSString *)username password:(NSString *)password
{
    NSCPassword *p = [[NSCPassword alloc] init];
    p.username = username;
    p.password = password;
    return p;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _username = [aDecoder valueForKey:@"username"];
        _password = [aDecoder valueForKey:@"password"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder setValue:self.username forKey:@"username"];
    [aCoder setValue:self.password forKey:@"password"];
}

@end
