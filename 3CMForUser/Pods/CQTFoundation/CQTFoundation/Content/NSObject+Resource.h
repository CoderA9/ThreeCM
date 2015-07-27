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
#import <UIKit/UIKit.h>

#pragma mark -

@interface NSObject(Resource)

+ (NSString *)stringFromResource:(NSString *)resName;
- (NSString *)stringFromResource:(NSString *)resName;

+ (NSData *)dataFromResource:(NSString *)resName;
- (NSData *)dataFromResource:(NSString *)resName;

+ (id)objectFromResource:(NSString *)resName;

- (NSArray *)getPropertyListByClass: (Class)clazz;
- (NSString *)nameWithInstance:(id)instance;

/* API返回的数据格式和序列化有冲突.此方法将不规则字典转换为规则的数组 */
+ (NSArray *)transformDic:(NSDictionary *)dictionary;

+ (double)getMathWithString:(NSString *)str;

+ (void)showiOSFont;

#define safelyStr(__obj) [NSObject stringSafety:(__obj)]
#define safelyAry(__obj) [NSObject arraySafety:(__obj)]
#define safelyMutableAry(__obj) [NSObject mutableArraySafety:(__obj)]

#define validObj(__obj) [NSObject checkValidObject:(__obj)]
#define validStr(__obj) [NSObject checkValidNSString:(__obj)]
#define validAry(__obj) [NSObject checkValidAry:(__obj)]
#define validMutableAry(__obj) [NSObject checkValidMutableAry:(__obj)]
#define validDic(__obj) [NSObject checkValidDictionary:(__obj)]
#define validMutableDic(__obj) [NSObject checkValidMutableDictionary:(__obj)]



+ (NSString *)stringSafety:(id)str;
+ (NSArray *)arraySafety:(id)list;
+ (NSMutableArray *)mutableArraySafety:(id)list ;

+ (BOOL)checkValidObject:(id)obj;

+ (BOOL)checkValidNSString:(NSString *)str;
+ (BOOL)checkValidMutableDictionary:(NSDictionary *)dic;
+ (BOOL)checkValidDictionary:(NSDictionary *)dic;
+ (BOOL)checkValidMutableAry:(NSMutableArray *)array;
+ (BOOL)checkValidAry:(NSArray *)array;

//遍历文件夹获得文件夹大小，返回多少M.
+ (float ) folderSizeAtPath:(NSString*) folderPath;
//单个文件的大小.
+ (long long) fileSizeAtPath:(NSString*) filePath;
/* 释放某些元素,某些类在销毁前必须要释放一些元素才能得到正常释放,这些内容都再此释放. */
- (void)releaseSomeElements;

+ (NSString *)messageStringWithCount:(int)count;
@end
