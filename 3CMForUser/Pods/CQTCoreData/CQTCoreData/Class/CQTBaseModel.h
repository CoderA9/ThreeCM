//
//  CQTBaseModel.h
//  CQTIda
//
//  Created by ANine on 4/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CQTIdaDataStructure.h"


#define kResultCountKey @"resultCount"



@interface CQTBaseModel : NSObject

@property (nonatomic, assign) BOOL	loaded;
@property (nonatomic,assign) BOOL needLoadmore;
@property (nonatomic,assign)int selectedIndex;

@property (retain) NSMutableArray *curNetModels;
@property (retain) NSMutableDictionary *curDownLoads;
/**
 重新初始化Model
 */
- (void)initialModel;
- (void)createModel;
- (void)createModels;

- (void)removeAllDownloads;
- (void)removeDownloadURL:(NSString*)url;

/* 处理错误信息. */
- (void)handleFailureRequestWithInfo:(NSDictionary *)errorInfo;
@end
