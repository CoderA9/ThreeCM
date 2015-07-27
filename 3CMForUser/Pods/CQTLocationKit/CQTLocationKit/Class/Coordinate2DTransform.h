//
//  Coordinate2DTransform.h
//  CQTIda
//
//  Created by ANine on 6/25/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

/**
 @brief 实现 地球坐标系统<=>火星坐标系统相互转换的方法.
 
 @discussion <#some problem description with this class#>
 */
@interface Coordinate2DTransform : NSObject


/* 
@mark 传入地球坐标系统,返回火星坐标系统.
@note 此坐标必须是中国区以内的坐标系统,否则返回地球坐标系统.
 */
+ (CLLocationCoordinate2D)tranformToMars:(CLLocationCoordinate2D)earthCoordinate;

/*
 @mark 传入火星坐标系统,返回地球坐标系统.
 @note 此坐标必须是中国区以内的坐标系统,否则返回火星坐标系统.此方法有1-2米的误差.
 */

+ (CLLocationCoordinate2D)tranformToEarths:(CLLocationCoordinate2D)marsCoordinate;


/* 判断该坐标是否已经超出中国经纬度范围以内.
   若超出,return YES ，else return NO.
 */
+ (BOOL)outOfChina:(CLLocationCoordinate2D)coordinate;

/* 将火星坐标系统转换为百度坐标系统. */
+ (CLLocationCoordinate2D)bd_encrypt:(CLLocationCoordinate2D)marsCoordinate;


/* 将百度坐标系统转换为火星坐标系统. */
+ (CLLocationCoordinate2D)bd_decrypt:(CLLocationCoordinate2D)baiduCoordinate;

@end
