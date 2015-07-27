//
//  CQTBaseModel.m
//  CQTIda
//
//  Created by ANine on 4/14/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#import "CQTBaseModel.h"
#import "NSDictionary+BeeExtension.h"
#import "Bee_Runtime.h"
#import "NSObject+BeeTypeConversion.h"
#import "Bee_LanguageSetting.h"

@implementation CQTBaseModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self createModel];
        [self createModels];
        [self initialModel];
    }
    return self;
}

- (void)initialModel {
    //subClass implemention this method.
}

- (void)createModel {
    //subClass implemention this method.
}
- (void)createModels {
    
    if (!self.curDownLoads) {
        _curDownLoads = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (!self.curNetModels) {
        _curNetModels = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //subClass implemention this method.
}
- (void)setModelDic:(NSDictionary *)pramas {
    [self setModelDic:pramas allCover:NO];
}

- (void)dealloc {
	
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    A9_ObjectReleaseSafely(_curNetModels);
    
    CQT_SUPER_DEALLOC();
}

#pragma mark - | ***** parser data ***** |

- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover {
    if (nil == pramas) {
        return;
    }
    //    NSDictionary *modelDic = [[RBDataManager sharedInstance] getClassPropertyDciWithModel:[self class]];
    NSArray *properties = [self getPropertyListByClass:[self class]];
    for (int index = 0 ; index < [properties count] ; index ++) {
        id obj = [properties objectAtIndex:index];
        NSString *propertyKey = [self nameWithInstance:obj];
//        NSString *key = [[ODDataManager sharedManager] fieldNameForProperty:propertyKey atModel:[self class]];
        assert(@"这里必须指定ModelMapping.");
        NSString *key = propertyKey;
        NSString *value = [pramas stringAtPath:key];
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@:",[NSString firstCaracterCapitalized:propertyKey]]);
        if ([self respondsToSelector:sel]) {
            if (cover) {
                [self performSelector:sel withObject:value];
            }else {
                if (value)   [self performSelector:sel withObject:value];
            }
        }
    }
}

- (void)setModelDic:(NSDictionary *)pramas class:(Class)oneClass {
    
    unsigned int		propertyCount = 0;
    objc_property_t *	properties = class_copyPropertyList( [self class], &propertyCount );
    
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        
        const char *	name = property_getName(properties[i]);
        NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
//        NSString *key = [[ODDataManager sharedManager] fieldNameForProperty:propertyName atModel:oneClass];
        assert(@"这里必须指定ModelMapping.");
        NSString *key = propertyName;
        if (nil == key) {
            
            key = propertyName;
        }
        
        const char *	attr = property_getAttributes(properties[i]);
        NSUInteger		type = [BeeTypeEncoding typeOf:attr];
        
        NSObject *	tempValue = [pramas objectForKey:key];
        NSObject *	value = nil;
        
        if ( tempValue )
        {
            if ( BeeTypeEncoding.NSNUMBER == type )
            {
                value = [tempValue asNSNumber];
            }
            else if ( BeeTypeEncoding.NSSTRING == type )
            {
                value = [tempValue asNSString];
            }
            else if ( BeeTypeEncoding.NSDATE == type )
            {
                value = [tempValue asNSDate];
            }
            else if ( BeeTypeEncoding.NSARRAY == type || BeeTypeEncoding.NSMUTABLEARRAY == type)
            {
                if ( [tempValue isKindOfClass:[NSArray class]] )
                {
                    SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                    if ( [self respondsToSelector:convertSelector] )
                    {
                        Class convertClass = [self performSelector:convertSelector];
                        if ( convertClass )
                        {
                            NSMutableArray * arrayTemp = [NSMutableArray array];
                            
                            for ( NSObject * tempObject in (NSArray *)tempValue )
                            {
                                if ( [tempObject isKindOfClass:[NSDictionary class]] )
                                {
                                    [arrayTemp addObject:[(NSDictionary *)tempObject objectForClass:convertClass]];
                                }
                            }
                            
                            value = arrayTemp;
                        }
                        else
                        {
                            value = tempValue;
                        }
                    }
                    else
                    {
                        value = tempValue;
                    }
                }
            }
            else if ( BeeTypeEncoding.NSDICTIONARY == type )
            {
                if ( [tempValue isKindOfClass:[NSDictionary class]] )
                {
                    SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyName] );
                    if ( [self respondsToSelector:convertSelector] )
                    {
                        Class convertClass = [self performSelector:convertSelector];
                        if ( convertClass )
                        {
                            value = [(NSDictionary *)tempValue objectForClass:convertClass];
                        }
                        else
                        {
                            value = tempValue;
                        }
                    }
                    else
                    {
                        value = tempValue;
                    }
                }
            }
            else if ( BeeTypeEncoding.OBJECT == type )
            {
                NSString * className = [BeeTypeEncoding classNameOfAttribute:attr];
                if ( [tempValue isKindOfClass:NSClassFromString(className)] )
                {
                    value = tempValue;
                }
                else if ( [tempValue isKindOfClass:[NSDictionary class]] )
                {
                    value = [(NSDictionary *)tempValue objectForClass:NSClassFromString(className)];
                }
            }
        }
        
        if ( nil != value )
        {
            [self setValue:value forKey:propertyName];
        }
    }
    
    free( properties );
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

- (NSString *)firstCaracterCapitalized:(NSString *)aString {
    if (!aString || !aString.length) {
        return aString;
    }
    NSString *returnStr ;
    char *echo = (char *)aString.UTF8String;
    char *p = echo;
    if ((' ' == *(echo -1) || echo == p) && 'a' <= *echo && 'z' >= *echo) {
        *echo= *echo - 32;
    }
    returnStr = [NSString stringWithUTF8String:echo];
    return returnStr;
}

#pragma mark - | ***** public methods ***** |
/* 处理错误信息. */
- (void)handleFailureRequestWithInfo:(NSDictionary *)errorInfo {
    
    NSString *resultcode = errorInfo[@"infoDic"][@"resultcode"];
    NSString *errorDesc = errorInfo[@"infoDic"][@"info"];
    
    NSString *errorDescLocal = _ERROR_MESSAGE(resultcode.intValue);
    //TODO:TOA9上线前修改
    if ([errorDescLocal isEqualToString:__TEXT(error_info_not_found)]) {
        
        errorDescLocal = NSStringFormat(@"%@:%@",resultcode,errorDesc);
    }
    
//    [self startProcessWithTitle:errorDescLocal];
//    [self finishProcessWithTitle:errorDescLocal timeLength:1.f];
}
@end
