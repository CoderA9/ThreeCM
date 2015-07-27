//
//  NSObject+HUD.h
//  CQTIda
//
//  Created by ANine on 7/31/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CQTAlertView.h"

@interface NSObject (HUD)

@property (nonatomic,assign,readonly)NSInteger hudTag;
@property (nonatomic,assign,readonly)BOOL isHud;

/* if the hud showing with a serious of startProcess.... the hudIsLoading is YES , instead is NO*/
@property (nonatomic,assign,readonly)BOOL hudIsLoading;

- (void)startProcessWithTitle:(NSString*)strTitle;
- (void)startProcessWithTitle:(NSString*)strTitle detailTitle:(NSString*)detailTitle;

- (void)startProcessWithTitle:(NSString*)strTitle detailTitle:(NSString*)detailTitle key:(NSString *)key;

- (void)finishProcessWithTitle:(NSString*)strTitle;
- (void)finishProcessWithTitleWaitLong:(NSString*)strTitle;

- (void)finishProcessWithTitle:(NSString*)strTitle timeLength:(CGFloat)timeLength;

- (void)finishProcessWithTitle:(NSString *)strTitle subTitle:(NSString *)subTitle timeLength:(CGFloat)timeLength  key:(NSString *)key;

- (void)finishProcess;

@end
