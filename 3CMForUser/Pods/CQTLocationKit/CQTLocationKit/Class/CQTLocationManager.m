//
//  CQTLocationManager.m
//  CQTIda
//
//  Created by ANine on 6/18/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTLocationManager.h"
#import "Coordinate2DTransform.h"


@implementation CQTLocationManager

/** 单例的获取对象
 
 @return 返回CQTLocationManager对象
 */
+ (instancetype)sharedManager {

    static CQTLocationManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedManager = [[self alloc] init];
        
    });
    
    return _sharedManager;
}

- (instancetype)init {
    
	if (self = [super init]) {
        
		self.manager = [[CLLocationManager alloc] init];
        
		self.manager.delegate = self;
        
        self.distanceFilter = DEFAULT_DISTANCE_FILTER;
        
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.manager.purpose = @"为您提供更精准的服务.";
        
        self.manager.distanceFilter = 1.0;
        
        if ([CLLocationManager locationServicesEnabled]) {
            
            if([self.manager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.manager performSelector:@selector(requestAlwaysAuthorization)];// 永久授权
//                [self.manager performSelector:@selector(requestWhenInUseAuthorization)];//使用中授权
            }
        }
	}
	return self;
}


- (void)setDistanceFilter:(int)distanceFilter {
    
    _distanceFilter = distanceFilter;
    
    self.manager.distanceFilter = _distanceFilter;
}

- (void)setDesiredAccuracy:(CLLocationAccuracy)desiredAccuracy {
    
    _desiredAccuracy = desiredAccuracy;
    
    self.manager.desiredAccuracy = desiredAccuracy;
}

- (void)reseverLocation:(CLLocation *)location comletionHandle:(void (^)(NSString *address , NSError *error))Handle {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            
            Handle(@"",error);
            
            return ;
        }
        
        CLPlacemark *mark = [placemarks firstObject];
        
        NSDictionary *addressDic = mark.addressDictionary;
        
        CQTDebugLog(@"%@",addressDic);

        Handle(NSStringFormat(@"%@%@%@%@%@%@",safelyStr(addressDic[@"Country"])
                              ,safelyStr(addressDic[@"State"])
                              ,safelyStr(addressDic[@"SubLocality"])
                              ,safelyStr(addressDic[@"Thoroughfare"])
                              ,safelyStr(addressDic[@"SubThoroughfare"])
                              ,safelyStr(addressDic[@"Name"])),nil);

        
    }];
}

#pragma mark - | ***** CLLocationManagerDelegate ***** |

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:[Coordinate2DTransform tranformToMars:newLocation.coordinate] altitude:newLocation.altitude horizontalAccuracy:newLocation.horizontalAccuracy verticalAccuracy:newLocation.verticalAccuracy timestamp:newLocation.timestamp];
    
    if (delegateRespond(self.delegate, locationManager:didUpdateToLocation:fromLocation:)) {
        
        [self.delegate locationManager:self didUpdateToLocation:location fromLocation:oldLocation];
    };
    
    A9_ObjectReleaseSafely(location);
}
 
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

}



#pragma mark - | ***** public methods ***** |
/* 根据两个经纬度之间的距离 */
+ (double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 long1:(double)long1 long2:(double)long2 {
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    
    return [curLocation distanceFromLocation:otherLocation];
}

+ (BOOL)isStartLocation {
    
    BOOL flag = NO;
    
    if ([CLLocationManager locationServicesEnabled]){
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            
            flag = YES;
        }
    }
    return flag;
}

@end
