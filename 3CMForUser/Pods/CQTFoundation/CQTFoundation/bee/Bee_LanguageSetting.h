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

#import "Bee_Precompile.h"
//#import "Bee_Foundation.h"
#import "Bee_Language.h"
#import "Bee_Singleton.h"
#pragma mark -

#undef	__TEXT
#define __TEXT( __x )	[[BeeLanguageSetting currentLanguage] stringWithName:(@#__x)]

#undef __TEXTSTR
#define __TEXTSTR( __x )	[[BeeLanguageSetting currentLanguage] stringWithName:(__x)]

#undef _BEETEXT
#define _BEETEXT(__x) [[BeeLanguageSetting currentLanguage] stringWithName:(@#__x)]

#undef _ERROR_MESSAGE
//#define _ERROR_MESSAGE(__x) [[BeeLanguageSetting sharedInstance] stringWithErrorName:[NSString stringWithFormat:@"cqt_network_error_domain_code_%d",(__x)]]
#define _ERROR_MESSAGE(__x) [[BeeLanguageSetting sharedInstance] stringWithErrorName:[NSString stringWithFormat:@"cqt_network_error_domain_code_not_use_%d",(__x)]]

#pragma mark -

@interface BeeLanguageSetting : NSObject

AS_SINGLETON( BeeLanguageSetting )

@property (nonatomic, retain) NSString *	name;

+ (BeeLanguage *)currentLanguage;
- (BeeLanguage *)currentLanguage;

+ (BOOL)setCurrentLanguage:(BeeLanguage *)lang;
- (BOOL)setCurrentLanguage:(BeeLanguage *)lang;

+ (BOOL)setCurrentLanguageName:(NSString *)name;
- (BOOL)setCurrentLanguageName:(NSString *)name;

+ (BOOL)setSystemLanguage;
- (BOOL)setSystemLanguage;

+ (NSString *)stringWithName:(NSString *)name;
- (NSString *)stringWithName:(NSString *)name;

+ (NSString *)stringWithErrorName:(NSString *)name;
- (NSString *)stringWithErrorName:(NSString *)name;
@end
