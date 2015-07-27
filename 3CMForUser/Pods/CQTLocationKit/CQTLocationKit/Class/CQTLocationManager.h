//
//  CQTLocationManager.h
//  CQTIda
//
//  Created by ANine on 6/18/14.//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>
/**
 @brief Location管理器
 
 @discussion <#some problem description with this class#>
 */

#define DEFAULT_DISTANCE_FILTER         50.f

@protocol CQTLocationManagerDelegate;

@interface CQTLocationManager : NSObject<CLLocationManagerDelegate> {
    
    CLLocationManager *_manager;
    
    __unsafe_unretained id <CQTLocationManagerDelegate>_delegate;
}


@property (nonatomic, unsafe_unretained) id<CQTLocationManagerDelegate> delegate;


@property (nonatomic, strong)CLLocationManager *manager;

@property (nonatomic, assign)int distanceFilter;

@property (nonatomic, assign)CLLocationAccuracy desiredAccuracy;

/** 单例的获取对象
 
 @return 返回LXLLocationController对象
 */
+ (instancetype)sharedManager;


/* 反地理编码,成功返回中文名,失败返回error */
- (void)reseverLocation:(CLLocation *)location comletionHandle:(void (^)(NSString *address , NSError *error))Handle;
@end



@protocol CQTLocationManagerDelegate <NSObject>

@required

/* 地理位置更新成功后调用的方法. 默认返回火星坐标系统.*/
- (void)locationManager:(CQTLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

/* 地理位置更新失败后调用的方法. */
-(void)locationManager:(CQTLocationManager *)manager didFailWithError:(NSError *)error;

/* 根据两个经纬度之间的距离 */
+ (double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 long1:(double)long1 long2:(double)long2;

/* 
    检测定位是否开启,或是否可以开启
    
    @return 如果用户已经开启,或未决定,则返回YES,
            否则返回NO.
 */
+ (BOOL)isStartLocation;

@end

