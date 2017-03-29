//
//  RNKitCodePushDeviceInfo.m
//  RNKitCodePushDeviceInfo
//
//  Created by SimMan on 2017/3/21.
//  Copyright © 2017年 RNKit.io All rights reserved.
//

#import "RNKitCodePushDeviceInfo.h"
@import UIKit;
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>


@implementation RNKitCodePushDeviceInfo

- (NSString*) deviceId
{
  struct utsname systemInfo;
  
  uname(&systemInfo);
  
  return [NSString stringWithCString:systemInfo.machine
                            encoding:NSUTF8StringEncoding];
}

- (NSString*) deviceName
{
  static NSDictionary* deviceNamesByCode = nil;
  
  if (!deviceNamesByCode) {
    
    deviceNamesByCode = @{@"i386"      :@"Simulator",
                          @"x86_64"    :@"Simulator",
                          @"iPod1,1"   :@"iPod Touch",      // (Original)
                          @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                          @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                          @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                          @"iPod5,1"   :@"iPod Touch",      // (Fifth Generation)
                          @"iPod7,1"   :@"iPod Touch",      // (Sixth Generation)
                          @"iPhone1,1" :@"iPhone",          // (Original)
                          @"iPhone1,2" :@"iPhone 3G",       // (3G)
                          @"iPhone2,1" :@"iPhone 3GS",      // (3GS)
                          @"iPad1,1"   :@"iPad",            // (Original)
                          @"iPad2,1"   :@"iPad 2",          //
                          @"iPad2,2"   :@"iPad 2",          //
                          @"iPad2,3"   :@"iPad 2",          //
                          @"iPad2,4"   :@"iPad 2",          //
                          @"iPad3,1"   :@"iPad",            // (3rd Generation)
                          @"iPad3,2"   :@"iPad",            // (3rd Generation)
                          @"iPad3,3"   :@"iPad",            // (3rd Generation)
                          @"iPhone3,1" :@"iPhone 4",        // (GSM)
                          @"iPhone3,2" :@"iPhone 4",        // iPhone 4
                          @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                          @"iPhone4,1" :@"iPhone 4S",       //
                          @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                          @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                          @"iPad3,4"   :@"iPad",            // (4th Generation)
                          @"iPad3,5"   :@"iPad",            // (4th Generation)
                          @"iPad3,6"   :@"iPad",            // (4th Generation)
                          @"iPad2,5"   :@"iPad Mini",       // (Original)
                          @"iPad2,6"   :@"iPad Mini",       // (Original)
                          @"iPad2,7"   :@"iPad Mini",       // (Original)
                          @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                          @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                          @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                          @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                          @"iPhone7,1" :@"iPhone 6 Plus",   //
                          @"iPhone7,2" :@"iPhone 6",        //
                          @"iPhone8,1" :@"iPhone 6s",       //
                          @"iPhone8,2" :@"iPhone 6s Plus",  //
                          @"iPhone8,4" :@"iPhone SE",       //
                          @"iPhone9,1" :@"iPhone 7",        // (model A1660 | CDMA)
                          @"iPhone9,3" :@"iPhone 7",        // (model A1778 | Global)
                          @"iPhone9,2" :@"iPhone 7 Plus",   // (model A1661 | CDMA)
                          @"iPhone9,4" :@"iPhone 7 Plus",   // (model A1784 | Global)
                          @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                          @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                          @"iPad4,3"   :@"iPad Air",        // 5th Generation iPad (iPad Air)
                          @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
                          @"iPad4,5"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Cellular)
                          @"iPad4,6"   :@"iPad Mini 2",     // (2nd Generation iPad Mini)
                          @"iPad4,7"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                          @"iPad4,8"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                          @"iPad4,9"   :@"iPad Mini 3",     // (3rd Generation iPad Mini)
                          @"iPad5,1"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                          @"iPad5,2"   :@"iPad Mini 4",     // (4th Generation iPad Mini)
                          @"iPad5,3"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                          @"iPad5,4"   :@"iPad Air 2",      // 6th Generation iPad (iPad Air 2)
                          @"iPad6,3"   :@"iPad Pro 9.7-inch",// iPad Pro 9.7-inch
                          @"iPad6,4"   :@"iPad Pro 9.7-inch",// iPad Pro 9.7-inch
                          @"iPad6,7"   :@"iPad Pro 12.9-inch",// iPad Pro 12.9-inch
                          @"iPad6,8"   :@"iPad Pro 12.9-inch",// iPad Pro 12.9-inch
                          @"AppleTV2,1":@"Apple TV",        // Apple TV (2nd Generation)
                          @"AppleTV3,1":@"Apple TV",        // Apple TV (3rd Generation)
                          @"AppleTV3,2":@"Apple TV",        // Apple TV (3rd Generation - Rev A)
                          @"AppleTV5,3":@"Apple TV",        // Apple TV (4th Generation)
                          };
  }
  
  NSString* deviceName = [deviceNamesByCode objectForKey:self.deviceId];
  
  if (!deviceName) {
    // Not found on database. At least guess main device type from string contents:
    
    if ([self.deviceId rangeOfString:@"iPod"].location != NSNotFound) {
      deviceName = @"iPod Touch";
    }
    else if([self.deviceId rangeOfString:@"iPad"].location != NSNotFound) {
      deviceName = @"iPad";
    }
    else if([self.deviceId rangeOfString:@"iPhone"].location != NSNotFound){
      deviceName = @"iPhone";
    }
  }
  
  return deviceName;
}

- (NSString*) userAgent
{
  UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
  return [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

- (NSString*) deviceLocale
{
  NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
  return language;
}

- (NSString*) deviceCountry
{
  NSString *country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
  return country;
}

- (NSString*) timezone
{
  NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
  return currentTimeZone.name;
}

- (NSString*) macAddress
{
  int mib[6];
  size_t len;
  char *buf;
  unsigned char *ptr;
  struct if_msghdr *ifm;
  struct sockaddr_dl *sdl;
  
  mib[0] = CTL_NET;
  mib[1] = AF_ROUTE;
  mib[2] = 0;
  mib[3] = AF_LINK;
  mib[4] = NET_RT_IFLIST;
  
  if ((mib[5] = if_nametoindex("en0")) == 0) {
    printf("Error: if_nametoindex error\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 1\n");
    return NULL;
  }
  
  if ((buf = malloc(len)) == NULL) {
    printf("Could not allocate memory. error!\n");
    return NULL;
  }
  
  if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
    printf("Error: sysctl, take 2");
    free(buf);
    return NULL;
  }
  
  ifm = (struct if_msghdr *)buf;
  sdl = (struct sockaddr_dl *)(ifm + 1);
  ptr = (unsigned char *)LLADDR(sdl);
  NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
  free(buf);
  
  return macString;
}

- (NSDictionary *)getDeviceInfo
{
  UIDevice *currentDevice = [UIDevice currentDevice];
  
  NSString *uniqueId = [RNKitCodePushDeviceUID uid];
  
  return @{
           @"systemName": currentDevice.systemName,
           @"systemVersion": currentDevice.systemVersion,
           @"model": self.deviceName,
           @"brand": @"Apple",
           @"deviceId": self.deviceId,
           @"deviceName": currentDevice.name,
           @"deviceLocale": self.deviceLocale,
           @"deviceCountry": self.deviceCountry ?: [NSNull null],
           @"uniqueId": uniqueId,
           @"bundleId": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"],
           @"appVersion": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
           @"buildNumber": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
           @"systemManufacturer": @"Apple",
           @"userAgent": self.userAgent,
           @"timezone": self.timezone,
           @"macAddress": self.macAddress
           };
}

- (NSString *)getDeviceInfoStr
{
    NSError *error;
    NSString *jsonString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self getDeviceInfo]
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString = @"{}";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSData *nsdata = [jsonString
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    return base64Encoded;
}


@end


@interface RNKitCodePushDeviceUID ()

@property(nonatomic, strong, readonly) NSString *uidKey;
@property(nonatomic, strong, readonly) NSString *uid;

@end

@implementation RNKitCodePushDeviceUID

@synthesize uid = _uid;

#pragma mark - Public methods

+ (NSString *)uid {
  return [[[RNKitCodePushDeviceUID alloc] initWithKey:@"deviceUID"] uid];
}

#pragma mark - Instance methods

- (id)initWithKey:(NSString *)key {
  self = [super init];
  if (self) {
    _uidKey = key;
    _uid = nil;
  }
  return self;
}

/*! Returns the Device UID.
 The UID is obtained in a chain of fallbacks:
 - Keychain
 - NSUserDefaults
 - Apple IFV (Identifier for Vendor)
 - Generate a random UUID if everything else is unavailable
 At last, the UID is persisted if needed to.
 */
- (NSString *)uid {
  if (!_uid) _uid = [[self class] valueForKeychainKey:_uidKey service:_uidKey];
  if (!_uid) _uid = [[self class] valueForUserDefaultsKey:_uidKey];
  if (!_uid) _uid = [[self class] appleIFV];
  if (!_uid) _uid = [[self class] randomUUID];
  [self save];
  return _uid;
}

/*! Persist UID to NSUserDefaults and Keychain, if not yet saved
 */
- (void)save {
  if (![RNKitCodePushDeviceUID valueForUserDefaultsKey:_uidKey]) {
    [RNKitCodePushDeviceUID setValue:_uid forUserDefaultsKey:_uidKey];
  }
  if (![RNKitCodePushDeviceUID valueForKeychainKey:_uidKey service:_uidKey]) {
    [RNKitCodePushDeviceUID setValue:_uid forKeychainKey:_uidKey inService:_uidKey];
  }
}

#pragma mark - Keychain methods

/*! Create as generic NSDictionary to be used to query and update Keychain items.
 *  param1
 *  param2
 */
+ (NSMutableDictionary *)keychainItemForKey:(NSString *)key service:(NSString *)service {
  NSMutableDictionary *keychainItem = [[NSMutableDictionary alloc] init];
  keychainItem[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;
  keychainItem[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAlways;
  keychainItem[(__bridge id)kSecAttrAccount] = key;
  keychainItem[(__bridge id)kSecAttrService] = service;
  return keychainItem;
}

/*! Sets
 *  param1
 *  param2
 */
+ (OSStatus)setValue:(NSString *)value forKeychainKey:(NSString *)key inService:(NSString *)service {
  NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
  keychainItem[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
  return SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
}

+ (NSString *)valueForKeychainKey:(NSString *)key service:(NSString *)service {
  OSStatus status;
  NSMutableDictionary *keychainItem = [[self class] keychainItemForKey:key service:service];
  keychainItem[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
  keychainItem[(__bridge id)kSecReturnAttributes] = (__bridge id)kCFBooleanTrue;
  CFDictionaryRef result = nil;
  status = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
  if (status != noErr) {
    return nil;
  }
  NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
  NSData *data = resultDict[(__bridge id)kSecValueData];
  if (!data) {
    return nil;
  }
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - NSUserDefaults methods

+ (BOOL)setValue:(NSString *)value forUserDefaultsKey:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
  return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)valueForUserDefaultsKey:(NSString *)key {
  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - UID Generation methods

+ (NSString *)appleIFV {
  if(NSClassFromString(@"UIDevice") && [UIDevice instancesRespondToSelector:@selector(identifierForVendor)]) {
    // only available in iOS >= 6.0
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
  }
  return nil;
}

+ (NSString *)randomUUID {
  if(NSClassFromString(@"NSUUID")) {
    return [[NSUUID UUID] UUIDString];
  }
  CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
  CFStringRef cfuuid = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
  CFRelease(uuidRef);
  NSString *uuid = [((__bridge NSString *) cfuuid) copy];
  CFRelease(cfuuid);
  return uuid;
}

@end
