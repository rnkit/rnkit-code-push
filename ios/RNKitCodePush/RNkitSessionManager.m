//
//  RNkitSessionManager.m
//  RNKitCodePush
//
//  Created by SimMan on 2017/8/14.
//  Copyright © 2017年 erica. All rights reserved.
//

#import "RNkitSessionManager.h"
#import "AFNetworking.h"

@implementation RNkitSessionManager

+ (void) uploadFileWithURL:(NSString *)url
                  fileName:(NSString *)fileName
                      file:(NSString *)filePath
                  mimeType:(NSString *)mimeType
                parameters:(NSDictionary *)parameters
           progressHandler:(void (^)(long long, long long))progressHandler
         completionHandler:(void (^)(id responseObject, NSError *error))completionHandler
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:mimeType error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      if (progressHandler) {
                          progressHandler(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
                      }
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (completionHandler) {
                          completionHandler(responseObject, error);
                      }
                  }];
    [uploadTask resume];
}

+ (void)download:(NSString *)downloadPath
        savePath:(NSString *)savePath
 progressHandler:(void (^)(long long, long long))progressHandler
completionHandler:(void (^)(NSString *path, NSError *error))completionHandler
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:downloadPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressHandler) {
            progressHandler(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionHandler) {
            if (error != nil) {
                completionHandler(nil, error);
            } else {
                NSFileManager *fm = [NSFileManager defaultManager];
                NSError *err;
                [fm moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:savePath] error:&err];
                if (err != nil) {
                    completionHandler(nil, error);
                } else {
                    completionHandler(savePath, nil);
                }
            }
        }
    }];
    [downloadTask resume];
}

@end
