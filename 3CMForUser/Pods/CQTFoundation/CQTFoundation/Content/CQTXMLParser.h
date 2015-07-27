//
//  CQTXMLParser.h
//  CQTIda
//
//  Created by ANine on 1/5/15.
//  Copyright (c) 2015 www.cqtimes.com. All rights reserved.
//


//Thanks to SHXMLParser

#import <Foundation/Foundation.h>

@interface CQTXMLParser : NSObject<NSXMLParserDelegate>
+ (NSArray *)convertDictionaryArray:(NSArray *)dictionaryArray toObjectArrayWithClassName:(NSString *)className classVariables:(NSArray *)classVariables;
+ (id)getDataAtPath:(NSString *)path fromResultObject:(NSDictionary *)resultObject;
+ (NSArray *)getAsArray:(id)object; //Utility function to get single NSDictionary object inside a array, if array is passed return the same

- (NSDictionary *)parseData:(NSData *)XMLData;

@end
