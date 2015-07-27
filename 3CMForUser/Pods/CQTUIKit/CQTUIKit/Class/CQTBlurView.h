//
//  CQTBlurView.h
//  CQTIda
//
//  Created by ANine on 5/12/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTView.h"

@interface CQTBlurView : CQTImgView

@property (nonatomic,retain)UIToolbar *toolbar;

@property (nonatomic,assign)BOOL needRespondScreenShot;//default is YES.

- (void)finishScreenShot;
@end
