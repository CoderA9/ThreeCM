//
//  NBMessageStatusReportView.h
//  twitBird
//
//  Created by wei li on 12/11/09.
//  Copyright 2009 nibirutech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_MESSAGE_STATUS_REPORT     @"NOTIFICATION_MESSAGE_STATUS_REPORT"

@interface CQTReportView : UIView {
	
	UILabel *textLabel;
	UIView  *backView;
	
	BOOL isFinishReport;
	NSString *strReport;

	UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic, assign) BOOL isFinishedReport;
@property (nonatomic, retain) NSString *strReport;

+ (CQTReportView *)sharedInstance;
+ (void)showStatus:(NSString *)status container:(UIView *)container;
- (void)show:(NSString *)status container:(UIView *)container;
- (void)stopActivityIndicator;
- (void)startActivityIndicator;

@end
