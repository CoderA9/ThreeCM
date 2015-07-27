//
//  UIButton+Extension.h
//  CQTIda
//
//  Created by ANine on 4/9/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 @brief UIButton的扩展类
 
 @discussion <#some problem description with this class#>
 */

//typedef void(^ANTouchUpInside)(UIButton *button);
//typedef void(^ANTouchUpDown)(UIButton *button);

typedef void(^A9ActionBlock)(UIButton * sender);


@interface UIButton (Extension)

@property (nonatomic ,retain)NSMutableDictionary *blockDic;
//@property (nonatomic , assign) ANTouchUpInside upInsideBlock;
//@property (nonatomic , assign) ANTouchUpDown downBlock;
//
//- (void)AN_setTouchUpInsideBlock:(ANTouchUpInside)block event:(UIControlEvents)event;

/* 制定一个事件就可以直接在block中写回调方法 */
- (void)A9_handleEvent:(UIControlEvents)event handle:(A9ActionBlock)block;

- (void)removeGlobalBlocks;

@end
