//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2013-2014, {Bee} open source community
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "NSObject+Resource.h"
//#import "NSObject+BeeJSON.h"
#import "CQTGlobalConstants.h"
#import "NSObject+BeeJSON.h"
#pragma mark -

@implementation NSObject(Resource)

+ (NSString *)stringFromResource:(NSString *)resName
{
	if ( nil == resName )
		return nil;

	NSString * extension = [resName pathExtension];
	NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
	
	return [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)stringFromResource:(NSString *)resName
{
	return [NSObject stringFromResource:resName];
}

+ (NSData *)dataFromResource:(NSString *)resName
{
	if ( nil == resName )
		return nil;
	
	NSString * extension = [resName pathExtension];
	NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
	NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];

	return [NSData dataWithContentsOfFile:resPath];
}

- (NSData *)dataFromResource:(NSString *)resName
{
	return [NSObject dataFromResource:resName];
}

+ (id)objectFromResource:(NSString *)resName
{
	NSString * content = [self stringFromResource:resName];
	if ( nil == content )
		return nil;
	
	NSObject * decodedObject = [self objectFromString:content];
	if ( nil == decodedObject )
		return nil;
	
	return decodedObject;
}

- (NSArray *)getPropertyListByClass: (Class)clazz
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertyArray;
}
- (NSString *)nameWithInstance:(id)instance
{
    if ([instance isKindOfClass:[NSString class]]) {
        return (NSString *)instance;
    }
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([self class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(self, thisIvar) == instance)) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}

/* API返回的数据格式和序列化有冲突.此方法将不规则字典转换为规则的数组 */
+ (NSArray *)transformDic:(NSDictionary *)dictionary {
    
    if (nil == dictionary) {
        return @[];
    }
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (id obj in dictionary.allValues) {
        
        [array addObject:obj];
    }
    return CQT_AUTORELEASE(array);
}

+ (double)getMathWithString:(NSString *)str {
    
    double result = 0.;
    
    NSArray *components = [str componentsSeparatedByString:@"/"];
    if (components && components.count == 2) {
        
        double fir = [components[0] doubleValue];
        double second = [components[1] doubleValue];
        
        result = fir/second;
    }else {
        
        result = [str doubleValue];
    }
    
    return result;
}

+ (void)showiOSFont {
    
    NSArray *familyNames = [UIFont familyNames];
    
    for( NSString *familyName in familyNames ) {
        
        printf( "Family: %s \n", [familyName UTF8String] );
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for( NSString *fontName in fontNames ) {
            
            printf( "\tFont: %s \n", [fontName UTF8String] );
        }
    }
}

+ (NSString *)stringSafety:(id)str {
    
    NSString *returnStr = @"";
    if (!str || [str isKindOfClass:[NSNull class]]) {
    }else if ([str isKindOfClass:[NSString class]]) {
        
        returnStr = str;
    }else if ([str isKindOfClass:[NSObject class]]) {
        
        returnStr = [NSString stringWithFormat:@"%@",str];
    }else if ([str isKindOfClass:[NSNumber class]]) {
    
        returnStr = [NSString stringWithFormat:@"%@",str];
    }else{
        returnStr = @"";
    }
    return returnStr;
}

+ (NSArray *)arraySafety:(id)list {
    
    NSArray *array = [[NSArray alloc] init];
    
    if (list && [list isKindOfClass:[NSArray class]]) {
        
        CQT_RELEASE(array);
        
        return list;
    }
    
    return CQT_AUTORELEASE(array);
}

+ (NSMutableArray *)mutableArraySafety:(id)list {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (list && [list isKindOfClass:[NSMutableArray class]]) {
        
        CQT_RELEASE(array);
        
        return list;
    }
    
    return CQT_AUTORELEASE(array);
}


+ (BOOL)checkValidObject:(id)obj {
    
    if (!obj) {
        
        return NO;
    }
    if ( [obj isKindOfClass:[NSArray class]] )
	{
        return [NSObject checkValidAry:obj];
	}
    else if ( [obj isKindOfClass:[NSMutableArray class]] )
	{
        return [NSObject checkValidMutableAry:obj];
	}
	else if ( [obj isKindOfClass:[NSDictionary class]] )
	{
        return [NSObject checkValidDictionary:obj];
	}
    else if ( [obj isKindOfClass:[NSMutableDictionary class]] )
	{
        return [NSObject checkValidMutableAry:obj];
	}
	else if ( [obj isKindOfClass:[NSString class]] )
	{
        return [NSObject checkValidNSString:obj];
	}
	else if ( [obj isKindOfClass:[NSData class]] )
	{
        
	}
    return NO;
}

+ (BOOL)checkValidAry:(NSArray *)array {
    
    BOOL valid = NO;
    
    if (!array) {
        
        return valid;
    }
    
    if (array && [array isKindOfClass:[NSArray class]] && array.count) {
        
        valid = YES;
    }
    
   return valid;
}

+ (BOOL)checkValidMutableAry:(NSMutableArray *)array {
    
    BOOL valid = NO;
    
    if (!array) {
        
        return valid;
    }
    
    if (array && [array isKindOfClass:[NSMutableArray class]] && array.count) {
        
        valid = YES;
    }
    
    return valid;
}

+ (BOOL)checkValidDictionary:(NSDictionary *)dic {
    
    BOOL valid = NO;
    
    if (!dic) {
        
        return valid;
    }
    
    if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.allKeys.count && dic.allValues.count) {
        
        valid = YES;
    }
    
    return valid;
}

+ (BOOL)checkValidMutableDictionary:(NSDictionary *)dic {
    
    BOOL valid = NO;
    
    if (!dic) {
        
        return valid;
    }
    
    if (dic && [dic isKindOfClass:[NSMutableDictionary class]] && dic.allKeys.count && dic.allValues.count) {
        
        valid = YES;
    }
    
    return valid;
}

+ (BOOL)checkValidNSString:(NSString *)str {
    
    BOOL valid = NO;
    
    if (!str) {
        
        return valid;
    }
    
    if (str && [str isKindOfClass:[NSString class]] && str.length) {
        
        valid = YES;
    }
    
    return valid;
}

//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [NSObject fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
}

/* 释放某些元素 */
- (void)releaseSomeElements {
    //subClass implementation this methods,if need.
}
+ (NSString *)messageStringWithCount:(int)count {
    
    NSString *resultStr = @"0";
    if (count < 0) {
        
        resultStr = @"0";
    }else if (count > 99) {
        
        resultStr = @"99+";
    }else {
        
        resultStr = [NSString stringWithFormat:@"%d",count];
    }
    
    return resultStr;
}

@end

// TODO: 0.5
