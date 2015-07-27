//
//  CQTTapGestureRecognizer.h
//  CQTIda
//
//  Created by ANine on 1/14/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQTTapGestureRecognizer : UITapGestureRecognizer {
    
    id _target;
    
    SEL _selctor;
}

@property (nonatomic,retain)NSSet *touches;

@property (nonatomic,retain)UIEvent *event;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end
