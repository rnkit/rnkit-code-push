//
//  RNKitCodePushConst.h
//  RNKitCodePush
//
//  Created by SimMan on 2017/8/13.
//  Copyright © 2017年 erica. All rights reserved.
//

#ifndef RNKitCodePushConst_h
#define RNKitCodePushConst_h

//
static NSString *const keyUpdateInfo = @"RNKIT_CODE_PUSH_INFO_KEY";
static NSString *const paramPackageVersion = @"packageVersion";
static NSString *const paramLastVersion = @"lastVersion";
static NSString *const paramCurrentVersion = @"currentVersion";
static NSString *const paramIsFirstTime = @"isFirstTime";
static NSString *const paramIsFirstLoadOk = @"isFirstLoadOK";
static NSString *const keyFirstLoadMarked = @"RNKIT_CODE_PUSH_FIRSTLOADMARKED_KEY";
static NSString *const keyRolledBackMarked = @"RNKIT_CODE_PUSH_ROLLEDBACKMARKED_KEY";
static NSString *const KeyPackageUpdatedMarked = @"RNKIT_CODE_PUSH_ISPACKAGEUPDATEDMARKED_KEY";

// app info
static NSString * const AppVersionKey = @"appVersion";
static NSString * const BuildVersionKey = @"buildVersion";

// file def
static NSString * const BUNDLE_FILE_NAME = @"index.bundlejs";
static NSString * const SOURCE_PATCH_NAME = @"__diff.json";
static NSString * const BUNDLE_PATCH_NAME = @"index.bundlejs.patch";

// error def
static NSString * const ERROR_OPTIONS = @"options error";
static NSString * const ERROR_BSDIFF = @"bsdiff error";
static NSString * const ERROR_FILE_OPERATION = @"file operation error";

// event def
static NSString * const EVENT_PROGRESS_DOWNLOAD = @"RNKitCodePushDownloadProgress";
static NSString * const EVENT_PROGRESS_UNZIP = @"RNKitCodePushUnzipProgress";
static NSString * const PARAM_PROGRESS_HASHNAME = @"hashname";
static NSString * const PARAM_PROGRESS_RECEIVED = @"received";
static NSString * const PARAM_PROGRESS_TOTAL = @"total";

#endif /* RNKitCodePushConst_h */
