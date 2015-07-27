//
//  RBDataBaseStructure.m
//  Robot
//
//  Created by A9 on 1/16/14.
//  Copyright (c) 2014 A9. All rights reserved.
//

#import "CQTDataBaseStructure.h"
#import "NSString+Extensions.h"

#import "Bee.h"

#import <objc/runtime.h>

#import "CQTResourceBrige.h"

@implementation CQTDataBaseStructure
#pragma mark - public Method
#pragma mark -
- (instancetype)init {
    
    if (self = [super init]) {
        
        [self createContainersIfNeeded];
        [self createObjectsIfNeeded];
    }
    return self;
}

- (void)createContainersIfNeeded {}
- (void)createObjectsIfNeeded {}
- (void)setModelDic:(NSDictionary *)pramas {
    [self setModelDic:pramas allCover:NO];
}
- (void)setModelDic:(NSDictionary *)pramas class:(Class)oneClass {
    
    [self setModelDic:pramas allCover:NO notReplaceKey:NO class:oneClass];
}
- (void)setModelDic:(NSDictionary *)pramas notReplaceKey:(BOOL)notReplace {
    [self setModelDic:pramas allCover:YES notReplaceKey:notReplace];
}
- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover {
    [self setModelDic:pramas allCover:cover notReplaceKey:NO];
}

- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover notReplaceKey:(BOOL)notReplace {
    
    [self setModelDic:pramas allCover:cover notReplaceKey:notReplace class:[self class]];
}

- (void)setModelDic:(NSDictionary *)pramas allCover:(BOOL)cover notReplaceKey:(BOOL)notReplace class:(Class)oneClass {
    
    if (nil == pramas) {
        return;
    }
    
    if (![[self class] isKindOfClass:[oneClass class]]) {
        
        [self setDic:pramas allCover:cover notReplaceKey:notReplace useClass:oneClass propertyClass:oneClass];
    }else {
        
       [self setDic:pramas allCover:cover notReplaceKey:notReplace useClass:oneClass propertyClass:[self class]];
    }
}


- (void)setDic:(NSDictionary *)pramas allCover:(BOOL)cover notReplaceKey:(BOOL)notReplace useClass:(Class)oneClass propertyClass:(Class)propertyClass {
    
    unsigned int propertyCount = 0;
    
    objc_property_t *properties  = class_copyPropertyList([propertyClass class], &propertyCount);
    for (int index = 0 ; index < propertyCount ; index ++) {
        const char *	name = property_getName(properties[index]);
        NSString *propertyKey = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];;
        
        const char *	attr = property_getAttributes(properties[index]);
        NSUInteger		type = [BeeTypeEncoding typeOf:attr];
        
        NSString *key;
        
        NSString *pKey = [NSString stringWithFormat:@"%@.idamodelmapping" , NSStringFromClass([oneClass class])];
        
        NSString *pValue = @"";
        
        NSDictionary *mapping = [CQTResourceBrige sharedBrige].modelMapping;
        
        if (mapping && mapping[pKey]) {
            
            pValue = mapping[pKey][propertyKey];
        }
        
        key = notReplace ? propertyKey :pValue;
        
        if(!key) {
            
            key = propertyKey;
        }
        NSString *tempValue = [pramas objectForKey:key];
        NSObject *value = nil;
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
                    SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyKey] );
                    if ( [oneClass respondsToSelector:convertSelector] )
                    {
                        Class convertClass = [oneClass performSelector:convertSelector];
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
                    SEL convertSelector = NSSelectorFromString( [NSString stringWithFormat:@"convertPropertyClassFor_%@", propertyKey] );
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
        
        if (cover) {
            
            [self setValue:value forKey:propertyKey];
            
        }else {
            
            if (value) {
                
                [self setValue:value forKey:propertyKey];
            }
        }
    }
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


- (NSString *)stringAtPath:(NSString *)path
{
    return path;
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

- (NSArray *)get222PropertyListByClass: (Class)clazz
{
    u_int count;
    
    objc_property_t *properties  = class_copyPropertyList(clazz, &count);
    
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char *	name = property_getName(properties[i]);
        NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        const char *	attr = property_getAttributes(properties[i]);
        NSUInteger		type = [BeeTypeEncoding typeOf:attr];
        
//        NSObject *	tempValue = [self objectForKey:propertyName];
        NSObject *	value = nil;

//        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertyArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *selector = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        SEL sel = sel_registerName([selector UTF8String]);
        
        [aCoder encodeObject:objc_msgSend(self, sel) forKey:selector];
    }
    
    free(properties);
    
    // 如果继承的基类不是NSObject，则继续
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self encodeWithCoder:aCoder withClass:[aClass superclass]];
    }
}

- (void)performSetterWithDecoder:(NSCoder *)aDecoder withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *properyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        NSString *selector =[NSString stringWithFormat:@"set%@:" ,
                             [properyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[properyName  substringToIndex:1] capitalizedString]]];
        SEL sel = sel_registerName([selector UTF8String]);
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:[aDecoder decodeObjectForKey:properyName]];
        }
        
    }
    
    free(properties);
    
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self performSetterWithDecoder:aDecoder withClass:[aClass superclass]];
    }
}

- (void)performPropertyCopy:(id)theCopy withClass:(Class)aClass {
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; i++)
    {
        NSString *properyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding] ;
        NSString *setterName =[NSString stringWithFormat:@"set%@:" ,
                               [properyName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[properyName  substringToIndex:1] capitalizedString]]];
        SEL getterSel = sel_registerName([properyName UTF8String]);
        SEL setterSel = sel_registerName([setterName UTF8String]);
        
        id getterObj = [[self performSelector:getterSel] copy];
        [theCopy performSelector:setterSel withObject:getterObj];
        
        // release
        getterObj = nil;
    }
    
    free(properties);
    
    
    if (![NSStringFromClass([aClass superclass]) isEqualToString:@"NSObject"]) {
        [self performPropertyCopy:theCopy withClass:[aClass superclass]];
    }
}

/**
 记录最后一次修改时间
 */
- (void)recordLastModify {
    
    self.lastModify = [NSString stringWithFormat:@"%lf",[[NSDate date] timeIntervalSince1970]];
}
#pragma mark - NSCoding & NSCopying Delegate

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self performSetterWithDecoder:aDecoder withClass:[self class]];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encodeWithCoder:aCoder withClass:[self class]];
}

- (id)copyWithZone:(NSZone *)zone {
    id theCopy = [[[self class] allocWithZone:zone] init]; // use designated initializer
    
    [self performPropertyCopy:theCopy withClass:[self class]];
    
    return theCopy;
}



@end
