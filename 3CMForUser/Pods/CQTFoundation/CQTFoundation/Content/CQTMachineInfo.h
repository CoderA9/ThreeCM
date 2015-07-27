//
//  CQTMachineInfo.h
//  CQTIda
//
//  Created by ANine on 4/11/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/sysctl.h>

typedef enum _iPhoneMechineType{
    iPhoneMechineTypeiPhone2G = 0,
    iPhoneMechineTypeiPhone3G ,
    iPhoneMechineTypeiPhone3GS,
    iPhoneMechineTypeiPhone4 ,
    iPhoneMechineTypeiPhone4_CDMA ,
    iPhoneMechineTypeiPhone4S ,
    iPhoneMechineTypeiPhone5 ,
    iPhoneMechineTypeiPhone5_GSM_CDMA ,
    iPhoneMechineTypeiPhone5C ,
    iPhoneMechineTypeiPhone5S,
    iPhoneMechineTypeiPhone6 ,
    iPhoneMechineTypeiPhone6Plus,
    iPhoneMechineTypeiPhoneMax  = 999,
    
    
    iPhoneMechineTypeiPod1 = 1000,
    iPhoneMechineTypeiPod2,
    iPhoneMechineTypeiPod3,
    iPhoneMechineTypeiPod4,
    iPhoneMechineTypeiPod5,
    iPhoneMechineTypeiPodMax = 1999,
    
    iPhoneMechineTypeiPad =  2000,
    iPhoneMechineTypeiPad_3G,
    iPhoneMechineTypeiPad_2_WiFi,
    iPhoneMechineTypeiPad_2,
    iPhoneMechineTypeiPad_2_CDMA,
    iPhoneMechineTypeiPad_2_Mini_WiFi,
    iPhoneMechineTypeiPad_Mini,
    iPhoneMechineTypeiPad_Mini_GSM_CDMA,
    iPhoneMechineTypeiPad_3_WiFi,
    iPhoneMechineTypeiPad_3_GSM_CDMA,
    iPhoneMechineTypeiPad_3,
    iPhoneMechineTypeiPad_4_WiFi,
    iPhoneMechineTypeiPad_4,
    iPhoneMechineTypeiPad_4_GSM_CDMA,
    iPhoneMechineTypeiPadMax = 2999,
}iPhoneMechineType;


//判断机型.
static NSString * A9_platformString(void) {
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

static iPhoneMechineType A9_getiPhoneMechineType(void){
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return iPhoneMechineTypeiPhone2G;
    if ([platform isEqualToString:@"iPhone1,2"])    return iPhoneMechineTypeiPhone3G;
    if ([platform isEqualToString:@"iPhone2,1"])    return iPhoneMechineTypeiPhone3GS;
    if ([platform isEqualToString:@"iPhone3,1"])    return iPhoneMechineTypeiPhone4;
    if ([platform isEqualToString:@"iPhone3,2"])    return iPhoneMechineTypeiPhone4;
    if ([platform isEqualToString:@"iPhone3,3"])    return iPhoneMechineTypeiPhone4_CDMA;
    if ([platform isEqualToString:@"iPhone4,1"])    return iPhoneMechineTypeiPhone4S;
    if ([platform isEqualToString:@"iPhone5,1"])    return iPhoneMechineTypeiPhone5;
    if ([platform isEqualToString:@"iPhone5,2"])    return iPhoneMechineTypeiPhone5_GSM_CDMA;
    if ([platform isEqualToString:@"iPhone5,3"])    return iPhoneMechineTypeiPhone5C;
    if ([platform isEqualToString:@"iPhone5,4"])    return iPhoneMechineTypeiPhone5C;
    if ([platform isEqualToString:@"iPhone6,1"])    return iPhoneMechineTypeiPhone5S;
    if ([platform isEqualToString:@"iPhone6,2"])    return iPhoneMechineTypeiPhone5S;
    if ([platform isEqualToString:@"iPhone7,1"])    return iPhoneMechineTypeiPhone6Plus;
    if ([platform isEqualToString:@"iPhone7,2"])    return iPhoneMechineTypeiPhone6;
    
    if ([platform isEqualToString:@"iPod1,1"])      return iPhoneMechineTypeiPod1;
    if ([platform isEqualToString:@"iPod2,1"])      return iPhoneMechineTypeiPod2;
    if ([platform isEqualToString:@"iPod3,1"])      return iPhoneMechineTypeiPod3;
    if ([platform isEqualToString:@"iPod4,1"])      return iPhoneMechineTypeiPod4;
    if ([platform isEqualToString:@"iPod5,1"])      return iPhoneMechineTypeiPod5;
    
    if ([platform isEqualToString:@"iPad1,1"])      return iPhoneMechineTypeiPad;
    if ([platform isEqualToString:@"iPad1,2"])      return iPhoneMechineTypeiPad_3G;
    if ([platform isEqualToString:@"iPad2,1"])      return iPhoneMechineTypeiPad_2_WiFi;
    if ([platform isEqualToString:@"iPad2,2"])      return iPhoneMechineTypeiPad_2;
    if ([platform isEqualToString:@"iPad2,3"])      return iPhoneMechineTypeiPad_2_CDMA;
    if ([platform isEqualToString:@"iPad2,4"])      return iPhoneMechineTypeiPad_2;
    if ([platform isEqualToString:@"iPad2,5"])      return iPhoneMechineTypeiPad_Mini;
    if ([platform isEqualToString:@"iPad2,6"])      return iPhoneMechineTypeiPad_Mini;
    if ([platform isEqualToString:@"iPad2,7"])      return iPhoneMechineTypeiPad_Mini_GSM_CDMA;
    if ([platform isEqualToString:@"iPad3,1"])      return iPhoneMechineTypeiPad_3_WiFi;
    if ([platform isEqualToString:@"iPad3,2"])      return iPhoneMechineTypeiPad_3_GSM_CDMA;
    if ([platform isEqualToString:@"iPad3,3"])      return iPhoneMechineTypeiPad_3;
    if ([platform isEqualToString:@"iPad3,4"])      return iPhoneMechineTypeiPad_4_WiFi;
    if ([platform isEqualToString:@"iPad3,5"])      return iPhoneMechineTypeiPad_4;
    if ([platform isEqualToString:@"iPad3,6"])      return iPhoneMechineTypeiPad_4_GSM_CDMA;
    
    
    //这里没有对5S做判断.为了能在5S上正常工作,默认返回为iPhone5.
    return iPhoneMechineTypeiPhone5;
}

//UI设计师设计高保真时使用的设备标准.调用此系列方法来获取不同设备下的相对高度。

#define heightBaseiPhone5(__x)            adjustHeightBase(iPhoneMechineTypeiPhone5,__x)
#define heightBaseiPhone6(__x)            adjustHeightBase(iPhoneMechineTypeiPhone6,__x)
#define heightBaseiPhone6Plus(__x)        adjustHeightBase(iPhoneMechineTypeiPhone6Plus,__x)

static float adjustHeightBase(iPhoneMechineType iPhoneType,float height) {
    
    CGSize size_iPhone5 = CGSizeMake(320,568);
    CGSize size_iPhone6 = CGSizeMake(375,667);
    CGSize size_iPhone6_Plus = CGSizeMake(414,736);
    
    float baseHeight = size_iPhone5.height;
    float deviceHeight = [UIScreen mainScreen].bounds.size.height;
    
    float baseWidth = size_iPhone5.width;
    float deviceWidth = [UIScreen mainScreen].bounds.size.width;
    
    if (deviceHeight < baseHeight) {
        
        deviceHeight = baseHeight;
    }
    
    switch (iPhoneType) {
            
        case iPhoneMechineTypeiPhone5:
            
            baseHeight = size_iPhone5.height;
            baseWidth  = size_iPhone5.width;
            break;
        case iPhoneMechineTypeiPhone6:
            
            baseHeight = size_iPhone6.height;
            baseWidth  = size_iPhone6.width;
            break;
        case iPhoneMechineTypeiPhone6Plus:
            
            baseHeight = size_iPhone6_Plus.height;
            baseWidth  = size_iPhone6_Plus.width;
            
            break;
        default:
            break;
    }

    return (baseWidth == deviceWidth) ? height :  height * deviceHeight / baseHeight;
}
