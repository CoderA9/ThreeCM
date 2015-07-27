//
//  UIGestureRecognizer+Extensions.m
//  CQTIda
//
//  Created by ANine on 1/14/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import "UIGestureRecognizer+Extensions.h"
#import <objc/runtime.h>
static char kGestureTagKey;

@implementation UIGestureRecognizer (Extensions)


- (void)setTag:(NSNumber *)tag {
    
    objc_setAssociatedObject(self,_cmd, tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)tag {
    
    return objc_getAssociatedObject(self, @selector(setTag:));
}
@end
