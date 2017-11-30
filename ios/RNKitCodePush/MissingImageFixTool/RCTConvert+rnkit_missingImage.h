//
//  RCTConvert+rnkit_missingImage.h
//  RNKitCodePush
//
//  Created by aevit on 2017/11/30.
//  Copyright © 2017年 erica. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 sometimes when patch completed, some images are missing, until 2017.11.30, still don't know why.
 so, use swizzle to solve this problem in the other way: if the image doesn't exist in the sanbox, search the bundle.
 
 @param _assetsPath the ReactNative Framework will put the images to directory "assets" in the main bundle by default, but when you change to the different directory, remember that the parameter "assetPath" should change too.
 @return
 */
void installMissingImageFixTool(NSString *_assetsPath);

/**
 swizzle origin methods
 */
void uninstallMissingImageFixTool();

