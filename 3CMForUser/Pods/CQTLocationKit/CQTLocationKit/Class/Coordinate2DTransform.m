//
//  Coordinate2DTransform.m
//  CQTIda
//
//  Created by ANine on 6/25/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "Coordinate2DTransform.h"

#define a  6378245.0

#define ee  0.00669342162296594323


@implementation Coordinate2DTransform

+ (CLLocationCoordinate2D)tranformToMars:(CLLocationCoordinate2D)earthCoordinate {
    
    CLLocationCoordinate2D marsCoordinate;
    
    if ([Coordinate2DTransform outOfChina:earthCoordinate]) {
        
        return earthCoordinate;
    }
    
    double dLat = [Coordinate2DTransform tranformLat:earthCoordinate.longitude - 105. :earthCoordinate.latitude - 35.];
    double dLon = [Coordinate2DTransform transformLon:earthCoordinate.longitude - 105. :earthCoordinate.latitude - 35.];
    
    double radLat = earthCoordinate.latitude / 180. * M_PI;
    
    double magic = sin(radLat);
    
    magic = 1 - ee * magic * magic;
    
    double sqrtMagic = sqrt(magic);
    
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    
    marsCoordinate.latitude = earthCoordinate.latitude + dLat;
    
    marsCoordinate.longitude = earthCoordinate.longitude + dLon;
    
    return marsCoordinate;
}


//thanks to @jack zhou https://github.com/JackZhouCn/JZLocationConverter/blob/master/JZLocationConverter.m
+ (CLLocationCoordinate2D)tranformToEarths:(CLLocationCoordinate2D)marsCoordinate {

    CLLocationCoordinate2D earthCoordinate;
    
    CLLocationCoordinate2D  gPt = [Coordinate2DTransform tranformToMars:marsCoordinate];
    
    double dLon = gPt.longitude - marsCoordinate.longitude;
    
    double dLat = gPt.latitude - marsCoordinate.latitude;
    
    earthCoordinate.latitude = marsCoordinate.latitude - dLat;
    
    earthCoordinate.longitude = marsCoordinate.longitude - dLon;
    
    return earthCoordinate;
}

+ (BOOL)outOfChina:(CLLocationCoordinate2D)coordinate {
    
    BOOL outof = NO;
    
    if (  coordinate.longitude   < 72.004   ||
          coordinate.longitude   > 137.8347 ||
          coordinate.latitude    < 0.8293   ||
          coordinate.latitude    > 55.8271)  {
        
        outof = YES;
    }
    
    return outof;
}


+ (double)tranformLat:(double)x :(double)y {
    
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    
    return ret;
}

+ (double)transformLon:(double)x :(double)y {
    
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    
    return ret;
}



const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
//参考链接:http://blog.csdn.net/coolypf/article/details/8569813
+ (CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)marsCoordinate {
    
    CLLocationCoordinate2D baiduCoordinate;
    
    double x = marsCoordinate.longitude, y = marsCoordinate.latitude;
    
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    baiduCoordinate.longitude = z * cos(theta) + 0.0065;
    
    baiduCoordinate.latitude = z * sin(theta) + 0.006;
    
    return baiduCoordinate;
}

+ (CLLocationCoordinate2D)bd_decrypt:(CLLocationCoordinate2D)baiduCoordinate {
    
    CLLocationCoordinate2D marsCoordinate;
    
    double x = baiduCoordinate.longitude - 0.0065, y = baiduCoordinate.latitude - 0.006;
    
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    marsCoordinate.longitude = z * cos(theta);
    
    marsCoordinate.latitude = z * sin(theta);
    
    return marsCoordinate;
}

@end
