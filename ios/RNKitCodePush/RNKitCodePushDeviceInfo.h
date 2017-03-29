//
//  RNKitCodePushDeviceInfo.h
//  RNKitCodePushDeviceInfo
//
//  Created by SimMan on 2017/3/21.
//  Copyright © 2017年 RNKit.io All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNKitCodePushDeviceInfo : NSObject
- (NSDictionary *) getDeviceInfo;
- (NSString *) getDeviceInfoStr;
@end

@interface RNKitCodePushDeviceUID : NSObject
+ (NSString *)uid;
@end
