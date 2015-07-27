//
//  LXJSONUtilities.h
//  LifeixNetworkKit
//
//  Created by James Liu on 1/15/12.
//  Copyright (c) 2012 Lifeix. All rights reserved.
//
//  Following infomations will be filled by Subversion automatically.
//  $Rev$
//  $Author$
//  $LastChangedDate$

#import <Foundation/Foundation.h>
#import "CJSONSerializer.h"
#import "CJSONDeserializer.h"


static NSData * LXJSONEncode(id object, NSError **error) {
    __unsafe_unretained NSData *data = nil;
    
    SEL _TouchJSONSelector = NSSelectorFromString(@"serializeObject:error:");
    Class _touchClass = (NSClassFromString(@"CJSONSerializer"));
    SEL _JSONKitSelector = NSSelectorFromString(@"JSONDataWithOptions:error:"); 
    SEL _SBJSONSelector = NSSelectorFromString(@"JSONRepresentation");
    SEL _YAJLSelector = NSSelectorFromString(@"yajl_JSONString");
    
    id _NSJSONSerializationClass = NSClassFromString(@"NSJSONSerialization");
    SEL _NSJSONSerializationSelector = NSSelectorFromString(@"dataWithJSONObject:options:error:");
    
    if (_touchClass) {
        id _touchSerializer = [_touchClass serializer];
        if (_touchSerializer && [_touchSerializer respondsToSelector:_TouchJSONSelector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_touchSerializer methodSignatureForSelector:_TouchJSONSelector]];
            invocation.target = _touchSerializer;
            invocation.selector = _TouchJSONSelector;
            
            __unsafe_unretained id tempObject = object;
            [invocation setArgument:&tempObject atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [invocation setArgument:&error atIndex:3];
            
            [invocation invoke];
            [invocation getReturnValue:&data];
            
        }
    } else if (_JSONKitSelector && [object respondsToSelector:_JSONKitSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:_JSONKitSelector]];
        invocation.target = object;
        invocation.selector = _JSONKitSelector;
        
        NSUInteger serializeOptionFlags = 0;
        [invocation setArgument:&serializeOptionFlags atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&error atIndex:3];
        
        [invocation invoke];
        [invocation getReturnValue:&data];
    } else if (_SBJSONSelector && [object respondsToSelector:_SBJSONSelector]) {
        __unsafe_unretained NSString *JSONString = nil;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:_SBJSONSelector]];
        invocation.target = object;
        invocation.selector = _SBJSONSelector;
        
        [invocation invoke];
        [invocation getReturnValue:&JSONString];
        
        data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    } else if (_YAJLSelector && [object respondsToSelector:_YAJLSelector]) {
        @try {
            __unsafe_unretained NSString *JSONString = nil;
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:_YAJLSelector]];
            invocation.target = object;
            invocation.selector = _YAJLSelector;
            
            [invocation invoke];
            [invocation getReturnValue:&JSONString];
            
            data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
        }
        @catch (NSException *exception) {
            *error = [[NSError alloc] initWithDomain:NSStringFromClass([exception class]) code:0 userInfo:[exception userInfo]];
        }
    } else if (_NSJSONSerializationClass && [_NSJSONSerializationClass respondsToSelector:_NSJSONSerializationSelector]) { 
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_NSJSONSerializationClass methodSignatureForSelector:_NSJSONSerializationSelector]];
        invocation.target = _NSJSONSerializationClass;
        invocation.selector = _NSJSONSerializationSelector;
        
        __unsafe_unretained id tempObject = object;
        [invocation setArgument:&tempObject atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        NSUInteger writeOptions = 0;
        [invocation setArgument:&writeOptions atIndex:3];
        [invocation setArgument:&error atIndex:4];
        
        [invocation invoke];
        [invocation getReturnValue:&data];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Please either target a platform that supports NSJSONSerialization or add one of the following libraries to your project: JSONKit, SBJSON, or YAJL", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"No JSON generation functionality available", nil) userInfo:userInfo] raise];
    }
    
    return data;
}

static id LXJSONDecode(NSData *data, NSError **error) {    
    
//    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Will process json: %@" , jsonString);
//    // release 
//    [jsonString release];
    
    __unsafe_unretained id JSON = nil;
    
    SEL _TouchJSONSelector = NSSelectorFromString(@"deserialize:error:");
    Class _touchClass = (NSClassFromString(@"CJSONDeserializer"));
    
    SEL _JSONKitSelector = NSSelectorFromString(@"objectFromJSONDataWithParseOptions:error:"); 
    SEL _SBJSONSelector = NSSelectorFromString(@"JSONValue");
    SEL _YAJLSelector = NSSelectorFromString(@"yajl_JSONWithOptions:error:");
    
    id _NSJSONSerializationClass = NSClassFromString(@"NSJSONSerialization");
    SEL _NSJSONSerializationSelector = NSSelectorFromString(@"JSONObjectWithData:options:error:");

    if (_touchClass) {
        id _touchDeserializer = [_touchClass deserializer];
        if (_touchDeserializer && [_touchDeserializer respondsToSelector:_TouchJSONSelector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_touchDeserializer methodSignatureForSelector:_TouchJSONSelector]];
            invocation.target = _touchDeserializer;
            invocation.selector = _TouchJSONSelector;
            
            __unsafe_unretained NSData *tempData = data;
            [invocation setArgument:&tempData atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
            [invocation setArgument:&error atIndex:3];
            
            [invocation invoke];
            [invocation getReturnValue:&JSON];

        }
    } else if (_JSONKitSelector && [data respondsToSelector:_JSONKitSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:_JSONKitSelector]];
        invocation.target = data;
        invocation.selector = _JSONKitSelector;
        
        NSUInteger parseOptionFlags = 0;
        [invocation setArgument:&parseOptionFlags atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&error atIndex:3];
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_SBJSONSelector && [NSString instancesRespondToSelector:_SBJSONSelector]) {
        // Create a string representation of JSON, to use SBJSON -`JSONValue` category method
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[string methodSignatureForSelector:_SBJSONSelector]];
        invocation.target = string;
        invocation.selector = _SBJSONSelector;
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_YAJLSelector && [data respondsToSelector:_YAJLSelector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[data methodSignatureForSelector:_YAJLSelector]];
        invocation.target = data;
        invocation.selector = _YAJLSelector;
        
        NSUInteger yajlParserOptions = 0;
        [invocation setArgument:&yajlParserOptions atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        [invocation setArgument:&error atIndex:3];
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else if (_NSJSONSerializationClass && [_NSJSONSerializationClass respondsToSelector:_NSJSONSerializationSelector]) { 
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[_NSJSONSerializationClass methodSignatureForSelector:_NSJSONSerializationSelector]];
        invocation.target = _NSJSONSerializationClass;
        invocation.selector = _NSJSONSerializationSelector;
        
        __unsafe_unretained NSData *tempData = data;
        [invocation setArgument:&tempData atIndex:2]; // arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
        NSUInteger readOptions = 0;
        [invocation setArgument:&readOptions atIndex:3];
        [invocation setArgument:&error atIndex:4];
        
        [invocation invoke];
        [invocation getReturnValue:&JSON];
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"Please either target a platform that supports NSJSONSerialization or add one of the following libraries to your project: JSONKit, SBJSON, or YAJL", nil) forKey:NSLocalizedRecoverySuggestionErrorKey];
        [NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"No JSON parsing functionality available", nil) userInfo:userInfo];
    }
    
    return JSON;
}

