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
#import "Bee_Singleton.h"
#pragma mark -

#undef	AS_PACKAGE
#define AS_PACKAGE( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end

#undef	DEF_PACKAGE
#define DEF_PACKAGE( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
			return [__class sharedInstance]; \
		} \
		@end

#undef	AS_PACKAGE_INSTANCE
#define AS_PACKAGE_INSTANCE( __parentClass, __class, __propertyName ) \
		@class __class; \
		@interface __parentClass (AutoLoad_##__propertyName) \
		@property (nonatomic, readonly) __class * __propertyName; \
		@end \
		@interface __class : NSObject \
		AS_SINGLETON( __class ); \
		@end

#undef	DEF_PACKAGE_INSTANCE
#define DEF_PACKAGE_INSTANCE( __parentClass, __class, __propertyName ) \
		@implementation __parentClass (AutoLoad_##__propertyName) \
		@dynamic __propertyName; \
		- (__class *)__propertyName \
		{ \
		return [__class sharedInstance]; \
		} \
		@end \
		@implementation __class \
		DEF_SINGLETON( __class ); \
		@end

#pragma mark -

@interface NSObject(AutoLoading)
+ (BOOL)autoLoad;
@end

#pragma mark -

@interface BeePackage : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSArray * loadedPackages;
@property (nonatomic, readonly) NSMutableDictionary * modelMapping;
@end
