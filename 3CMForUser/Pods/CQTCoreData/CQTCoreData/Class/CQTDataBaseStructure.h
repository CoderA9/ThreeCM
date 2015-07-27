//
//  RBDataBaseStructure.h
//  Robot
//
//  Created by A9 on 1/16/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 所有需要序列化以及可copy的对象的父类.
 */
@interface CQTDataBaseStructure : NSObject <NSCoding , NSCopying>

@property (nonatomic,strong)NSString *lastModify;
/**
 记录最后一次提交时间
 */
- (void)recordLastModify;

/* 创建数据结构中得数组 */
- (void)createContainersIfNeeded;

/* 创建数据结构中的对象 */
- (void)createObjectsIfNeeded ;


/**
 初始化类,传入的参数需要替换key,完全覆盖.
 */
- (void)setModelDic:(NSDictionary *)pramas;
/**
 初始化类,传入的参数需要自定义替换key,完全覆盖.
 */
- (void)setModelDic:(NSDictionary *)pramas notReplaceKey:(BOOL)notReplace;
/**
 初始化类,传入的参数,需要替换key,自定义覆盖.
 */
- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover;
/**
 初始化类,传入的参数,自定义替换key,自定义覆盖.
 */
- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover notReplaceKey:(BOOL)notReplace;
/* 增加方法适配继承情况下,初始化数据时对象错误问题. */
- (void)setModelDic:(NSDictionary *)pramas class:(Class)oneClass;
@end
