//
//  RNKitMissingImageFixToolBridge.m
//  RNKitCodePush
//
//  Created by aevit on 2017/11/30.
//  Copyright © 2017年 erica. All rights reserved.
//

#import "RNKitMissingImageFixToolBridge.h"
#import "RCTConvert+rnkit_missingImage.h"

@implementation RNKitMissingImageFixToolBridge

RCT_EXPORT_MODULE(RNKitMissingImageFixToolBridge);

RCT_EXPORT_METHOD(installMissingImageFixTool:(NSString*)assetsPath) {
    installMissingImageFixTool(assetsPath);
}

RCT_EXPORT_METHOD(uninstallMissingImageFixTool) {
    uninstallMissingImageFixTool();
}

@end
