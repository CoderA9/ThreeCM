//
//  UIButton+Extension.m
//  CQTIda
//
//  Created by ANine on 4/9/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "UIButton+Extension.h"


#import <objc/runtime.h>
enum {
    AN_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
    AN_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object.
                                            *   The association is not made atomically. */
    AN_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied.
                                            *   The association is not made atomically. */
    AN_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
                                            *   The association is made atomically. */
    AN_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
                                            *   The association is made atomically. */
};


static char ANBtnEventBlockKey;


@implementation UIButton (Extension)

#pragma mark - | ***** public Methods ***** |

- (void)A9_handleEvent:(UIControlEvents)event handle:(void(^)(UIButton * sender))block {
    
    NSString *methodName = [self eventName:event];
    
    self.blockDic = (NSMutableDictionary*)objc_getAssociatedObject(self, &ANBtnEventBlockKey);
    

    [self.blockDic setObject:CQT_AUTORELEASE([block copy]) forKey:methodName];
    
    
    [self addTarget:self action:NSSelectorFromString(methodName) forControlEvents:event];
}

#pragma mark - | ***** private Methods ***** |

- (NSString *)eventName:(UIControlEvents)event {
    NSString *methodName = nil;
    switch (event) {
        case UIControlEventTouchDown:
            methodName = @"CQTButton_UIControlEventTouchDown";
            break;
        case UIControlEventTouchDownRepeat:
            methodName = @"CQTButton_UIControlEventTouchDownRepeat";
            break;
        case UIControlEventTouchDragInside:
            methodName = @"CQTButton_UIControlEventTouchDragInside";
            break;
        case UIControlEventTouchDragOutside:
            methodName = @"CQTButton_UIControlEventTouchDragOutside";
            break;
        case UIControlEventTouchDragEnter:
            methodName = @"CQTButton_UIControlEventTouchDragEnter";
            break;
        case UIControlEventTouchDragExit:
            methodName = @"CQTButton_UIControlEventTouchDragExit";
            break;
        case UIControlEventTouchUpInside:
            methodName = @"CQTButton_UIControlEventTouchUpInside";
            break;
        case UIControlEventTouchUpOutside:
            methodName = @"CQTButton_UIControlEventTouchUpOutside";
            break;
        case UIControlEventTouchCancel:
            methodName = @"CQTButton_UIControlEventTouchCancel";
            break;
        case UIControlEventValueChanged:
            methodName = @"CQTButton_UIControlEventValueChanged";
            break;
        case UIControlEventEditingDidBegin:
            methodName = @"CQTButton_UIControlEventEditingDidBegin";
            break;
        case UIControlEventEditingChanged:
            methodName = @"CQTButton_UIControlEventEditingChanged";
            break;
        case UIControlEventEditingDidEnd:
            methodName = @"CQTButton_UIControlEventEditingDidEnd";
            break;
        case UIControlEventEditingDidEndOnExit:
            methodName = @"CQTButton_UIControlEventEditingDidEndOnExit";
            break;
        case UIControlEventAllTouchEvents:
            methodName = @"CQTButton_UIControlEventAllTouchEvents";
            break;
        case UIControlEventAllEditingEvents:
            methodName = @"CQTButton_UIControlEventAllEditingEvents";
            break;
        case UIControlEventApplicationReserved:
            methodName = @"CQTButton_UIControlEventApplicationReserved";
            break;
        case UIControlEventSystemReserved:
            methodName = @"CQTButton_UIControlEventSystemReserved";
            break;
        case UIControlEventAllEvents:
            methodName = @"CQTButton_UIControlEventAllEvents";
            break;
        default:
            break;
    }
    return methodName;
}

-(void)CQTButton_UIControlEventTouchDown {
    [self CQTButton_callActionBlock:UIControlEventTouchDown];
}

-(void)CQTButton_UIControlEventTouchDownRepeat {
    [self CQTButton_callActionBlock:UIControlEventTouchDownRepeat];
}

-(void)CQTButton_UIControlEventTouchDragInside {
    [self CQTButton_callActionBlock:UIControlEventTouchDragInside];
}

-(void)CQTButton_UIControlEventTouchDragOutside {
    [self CQTButton_callActionBlock:UIControlEventTouchDragOutside];
}

-(void)CQTButton_UIControlEventTouchDragEnter {
    [self CQTButton_callActionBlock:UIControlEventTouchDragEnter];
}

-(void)CQTButton_UIControlEventTouchDragExit {
    [self CQTButton_callActionBlock:UIControlEventTouchDragExit];
}

-(void)CQTButton_UIControlEventTouchUpInside {
    [self CQTButton_callActionBlock:UIControlEventTouchUpInside];
}

-(void)CQTButton_UIControlEventTouchUpOutside {
    [self CQTButton_callActionBlock:UIControlEventTouchUpOutside];
}

-(void)CQTButton_UIControlEventTouchCancel {
    [self CQTButton_callActionBlock:UIControlEventTouchCancel];
}

-(void)CQTButton_UIControlEventValueChanged {
    [self CQTButton_callActionBlock:UIControlEventValueChanged];
}

-(void)CQTButton_UIControlEventEditingDidBegin {
    [self CQTButton_callActionBlock:UIControlEventEditingDidBegin];
}

-(void)CQTButton_UIControlEventEditingChanged {
    [self CQTButton_callActionBlock:UIControlEventEditingChanged];
}

-(void)CQTButton_UIControlEventEditingDidEnd {
    [self CQTButton_callActionBlock:UIControlEventEditingDidEnd];
}

-(void)CQTButton_UIControlEventEditingDidEndOnExit {
    [self CQTButton_callActionBlock:UIControlEventEditingDidEndOnExit];
}

-(void)CQTButton_UIControlEventAllTouchEvents {
    [self CQTButton_callActionBlock:UIControlEventAllTouchEvents];
}

-(void)CQTButton_UIControlEventAllEditingEvents {
    [self CQTButton_callActionBlock:UIControlEventAllEditingEvents];
}

-(void)CQTButton_UIControlEventApplicationReserved {
    [self CQTButton_callActionBlock:UIControlEventApplicationReserved];
}

-(void)CQTButton_UIControlEventSystemReserved {
    [self CQTButton_callActionBlock:UIControlEventSystemReserved];
}

-(void)CQTButton_UIControlEventAllEvents {
    [self CQTButton_callActionBlock:UIControlEventAllEvents];
}

- (void)CQTButton_callActionBlock:(UIControlEvents)event {

    NSMutableDictionary *opreations = (NSMutableDictionary*)objc_getAssociatedObject(self, &ANBtnEventBlockKey);
    if(opreations == nil) return;
    void(^block)(id sender) = [opreations objectForKey:[self eventName:event]];
    
    if (block) block(self);

}


- (void)setBlockDic:(NSMutableDictionary *)blockDic {
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &ANBtnEventBlockKey);
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
    }
    objc_setAssociatedObject(self, &ANBtnEventBlockKey, dic, OBJC_ASSOCIATION_RETAIN);

}

- (NSMutableDictionary *)blockDic {
    
   return (NSMutableDictionary*)objc_getAssociatedObject(self, &ANBtnEventBlockKey);
}

- (void)removeGlobalBlocks {
    
    if (self.blockDic) {
        
        NSMutableDictionary *dic = [self.blockDic copy];
        
        for (NSString * string in dic.allKeys) {
            
            [self.blockDic removeObjectForKey:string];
            
            CQT_BLOCK_RELEASE(block);
        }
        
        dic = nil;
    }
}


- (void)dealloc {

    CQT_SUPER_DEALLOC();
}
@end
