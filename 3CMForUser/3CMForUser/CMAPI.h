//
//  CMAPI.h
//  3CMForUser
//
//  Created by ANine on 7/27/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "LXHTTPEngine.h"

@interface CMAPI : LXHTTPEngine

typedef void (^CMAPIClientSuccessBlock) ( id dataBody);
typedef void (^CMAPIClientFailureBlock) ( id dataBody);
typedef void (^CMAPIClientUploaderBlock) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);

@end
