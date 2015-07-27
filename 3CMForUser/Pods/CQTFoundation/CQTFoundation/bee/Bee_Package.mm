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

#import "Bee_Package.h"
#import "Bee_Singleton.h"
//#import "Bee_SystemInfo.h"
#import "NSArray+BeeExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

BeePackage * bee = nil;

#pragma mark -

@implementation NSObject(AutoLoading)

+ (BOOL)autoLoad
{
	return YES;
}

@end

#pragma mark -

@interface BeePackage()
{
	NSMutableArray * _loadedPackages;
    
    NSMutableDictionary *_modelMapping;
}

AS_SINGLETON( BeePackage )

@end

#pragma mark -

@implementation BeePackage

DEF_SINGLETON( BeePackage )

@synthesize loadedPackages = _loadedPackages;

+ (void)load
{
	[BeePackage sharedInstance];
}


- (id)init
{
	self = [super init];
	if ( self )
	{
		_loadedPackages = BEE_RETAIN([NSMutableArray nonRetainingArray]);

		[self loadClasses];
        
        [self extractModelsMapping];
		
		bee = self;
	}
	return self;
}

- (void)dealloc
{
    
	[_loadedPackages removeAllObjects];
	BEE_RELEASE(_loadedPackages);
	
    [_modelMapping removeAllObjects];
    BEE_RELEASE(_modelMapping);
    
	BEE_SUPER_DEALLOC();
}

- (void)loadClasses
{
	const char * autoLoadClasses[] = {
		"BeeLogger",
	#if (TARGET_OS_MAC)
		"BeeCLI",
	#endif	// #if (TARGET_OS_MAC)
		"BeeReachability",
		"BeeHTTPConfig",
		"BeeHTTPMockServer",
		"BeeActiveRecord",
		"BeeModel",
		"BeeController",
		"BeeService",
		"BeeLanguageSetting",
		"BeeUIStyleManager",
		"BeeUITemplateParser",
		"BeeUITemplateManager",
		"BeeUIKeyboard",

		// TODO: ADD MORE CLASSES HERE

		"BeeUnitTest",
		"BeeSingleton",
		NULL
	};
	
	NSUInteger total = 0;
	
	for ( NSInteger i = 0;; ++i )
	{
		const char * className = autoLoadClasses[i];
		if ( NULL == className )
			break;
		
		Class classType = NSClassFromString( [NSString stringWithUTF8String:className] );
		if ( classType )
		{
			BOOL succeed = [classType autoLoad];
			if ( succeed )
			{
				[_loadedPackages addObject:classType];
			}
		}
		
		total += 1;
	}
}

- (void)extractModelsMapping {
    
    NSString *modelsFolder = [NSString stringWithFormat:@"%@/Modelmapping" , [[NSBundle mainBundle] resourcePath]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:modelsFolder error:&error];
    if (error) {
        return;
    }
    
    for (NSString *fileName in files) {
        NSString *path = [NSString stringWithFormat:@"%@/%@" , modelsFolder , fileName];
        NSData *data = [fileManager contentsAtPath:path];
        if (!data)
            continue;
        NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!contents)
            continue;
        
        NSArray *lines = [contents componentsSeparatedByString:@"\n"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[lines count]];
        for (NSString *line in lines) {
            NSArray *fields = [line componentsSeparatedByString:@"---"];
            if (!fields || [fields count] != 2)
                continue;
            
            NSString *key = [fields objectAtIndex:0];
            NSString *value = [fields objectAtIndex:1];
            
            [dic setObject:value forKey:key];
        }
        
        if (!_modelMapping) {
            _modelMapping = [[NSMutableDictionary alloc] initWithCapacity:[files count]];
        }
        
        [_modelMapping setObject:dic forKey:fileName];
    }
}
//
- (NSMutableDictionary *)modelMapping {
    
    if (_modelMapping) {
        
        return _modelMapping;
    }
    
    [self extractModelsMapping];
    
    return _modelMapping;
}


@end
