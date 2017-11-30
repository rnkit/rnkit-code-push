//
//  RCTConvert+rnkit_missingImage.m
//  RNKitCodePush
//
//  Created by aevit on 2017/11/30.
//  Copyright © 2017年 erica. All rights reserved.
//

#import "RCTConvert+rnkit_missingImage.h"
#import <React/RCTImageSource.h>
#import <objc/runtime.h>
#import "RNKitCodePush.h"

@implementation RCTConvert (rnkit_missingImage)
static BOOL sc_installed = NO;
static NSString *sc_assetsPath = nil;

#pragma mark ---------- public methods
void installMissingImageFixTool(NSString *_assetsPath) {
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    if (!sc_installed) {
        sc_installed = YES;
        sc_assetsPath = _assetsPath ?: @"assets/";
        swizzleRCTImageSourceMethod();
    }
    dispatch_semaphore_signal(lock);
}

void uninstallMissingImageFixTool() {
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    if (sc_installed) {
        sc_installed = NO;
        sc_assetsPath = nil;
        swizzleRCTImageSourceMethod();
    }
    dispatch_semaphore_signal(lock);
}

#pragma mark - private methods
void swizzleRCTImageSourceMethod() {
    
    Class class = object_getClass((id)[RCTConvert class]);
    
    SEL originalSel = sel_registerName("RCTImageSource:");
    SEL swizzleSel = sel_registerName("swizzleRCTImageSource:");
    
    Method originalMethod = class_getClassMethod(class, originalSel);
    Method swizzleMethod = class_getClassMethod(class, swizzleSel);
    
    BOOL success = class_addMethod(class, originalSel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (success) {
        class_replaceMethod(class, swizzleSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
}

+ (RCTImageSource *)swizzleRCTImageSource:(id)json {
    if ([RNKitCodePush hasUpdateInfo] && json && [json isKindOfClass:[NSDictionary class]] && json[@"uri"] && [json[@"uri"] hasPrefix:@"file://"]) {
        NSString *path = json[@"uri"];
        if (![[self class] isExistInRNKitCodePush:path]) {
            path = [[self class] convertToBundlePath:path];
            if (path) {
                NSMutableDictionary *aDict = [NSMutableDictionary dictionaryWithDictionary:json];
                aDict[@"uri"] = [NSString stringWithFormat:@"file://%@", path];
                return [RCTConvert swizzleRCTImageSource:aDict];
            }
        }
    }
    return [RCTConvert swizzleRCTImageSource:json];
}

+ (BOOL)isExistInRNKitCodePush:(NSString*)uri {
    NSString *path = [uri stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSRange range = [path rangeOfString:@"rnkitcodepush/"];
    if (range.location != NSNotFound) {
        path = [NSString stringWithFormat:@"%@/%@", [RNKitCodePush downloadDir], [path substringFromIndex:(range.location + range.length)]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return YES;
        }
    }
    return NO;
}

+ (NSString*)convertToBundlePath:(NSString*)uri {
    NSString *path = [uri stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSRange range = [path rangeOfString:sc_assetsPath];
    if (range.location != NSNotFound) {
        path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], [path substringFromIndex:range.location]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return path;
        }
    }
    return nil;
}

@end
