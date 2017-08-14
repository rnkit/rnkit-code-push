//
//  RNkitSessionManager.h
//  RNKitCodePush
//
//  Created by SimMan on 2017/8/14.
//  Copyright © 2017年 erica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNkitSessionManager : NSObject

+ (void) uploadFileWithURL:(NSString *)url
                  fileName:(NSString *)fileName
                      file:(NSString *)filePath
                  mimeType:(NSString *)mimeType
                parameters:(NSDictionary *)parameters
           progressHandler:(void (^)(long long, long long))progressHandler
         completionHandler:(void (^)(id responseObject, NSError *error))completionHandler;

+ (void)download:(NSString *)downloadPath
        savePath:(NSString *)savePath
 progressHandler:(void (^)(long long, long long))progressHandler
completionHandler:(void (^)(NSString *path, NSError *error))completionHandler;

@end
