//
//  RNKitCodePushDownloader.h
//  RNKitCodePush
//
//  Created by LvBingru on 2/19/16.
//  Copyright © 2016 erica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNKitCodePushDownloader : NSObject

+ (void)download:(NSString *)downloadPath savePath:(NSString *)savePath
    progressHandler:(void (^)(long long, long long))progressHandler
completionHandler:(void (^)(NSString *path, NSError *error))completionHandler;

@end
