//
//  LXGlobalCorePaths.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/17/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import "LXGlobalCorePaths.h"

static NSBundle* globalBundle = nil;

BOOL LXIsBundleURL(NSString* URL) {
    return [URL hasPrefix:@"bundle://"];
}

BOOL LXIsDocumentsURL(NSString* URL) {
    return [URL hasPrefix:@"documents://"];
}

void LXSetDefaultBundle(NSBundle* bundle) {
    globalBundle = bundle;
}

NSBundle* LXGetDefaultBundle() {
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}


NSString* CQTPathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [LXGetDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}


NSString* CQTPathForDocumentsResource(NSString* relativePath) {
    
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsPath = [dirs objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString* CQTPathForCachesResource(NSString* relativePath) {
    
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                        NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath  = [dirs objectAtIndex:0];
    
    return [cachesPath stringByAppendingPathComponent:relativePath];
}
