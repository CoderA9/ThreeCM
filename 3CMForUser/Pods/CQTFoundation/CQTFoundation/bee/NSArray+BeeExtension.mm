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

#import "NSArray+BeeExtension.h"

#import "Bee_UnitTest.h"
#import "NSObject+BeeTypeConversion.h"
#import "NSDate+BeeExtension.h"
// ----------------------------#import "NSObject+BeeTypeConversion.h"------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(BeeExtension)

@dynamic APPEND;
@dynamic mutableArray;

- (NSArrayAppendBlock)APPEND
{
	NSArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		NSMutableArray * array = [NSMutableArray arrayWithArray:self];
		[array addObject:obj];
		return array;
	};
	
	return BEE_AUTORELEASE([block copy]);
}

- (NSArray *)head:(NSUInteger)count
{
	if ( [self count] < count )
	{
		return self;
	}
	else
	{
		NSMutableArray * tempFeeds = [NSMutableArray array];
		for ( NSObject * elem in self )
		{
			[tempFeeds addObject:elem];
			if ( [tempFeeds count] >= count )
				break;
		}
		return tempFeeds;
	}
}

- (NSArray *)tail:(NSUInteger)count
{	
//	if ( [self count] < count )
//	{
//		return self;
//	}
//	else
//	{
//        NSMutableArray * tempFeeds = [NSMutableArray array];
//		
//        for ( NSUInteger i = 0; i < count; i++ )
//		{
//            [tempFeeds insertObject:[self objectAtIndex:[self count] - i] atIndex:0];
//        }
//
//		return tempFeeds;
//	}

// thansk @lancy, changed: NSArray tail: count

	NSRange range = NSMakeRange( self.count - count, count );
	return [self subarrayWithRange:range];
}

- (id)safeObjectAtIndex:(NSInteger)index
{
	if ( index < 0 )
		return nil;
	
	if ( index >= self.count )
		return nil;

	return [self objectAtIndex:index];
}

- (NSArray *)safeSubarrayWithRange:(NSRange)range
{
	if ( 0 == self.count )
		return nil;

	if ( range.location >= self.count )
		return nil;

	if ( range.location + range.length >= self.count )
		return nil;
	
	return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

- (NSMutableArray *)mutableArray
{
	return [NSMutableArray arrayWithArray:self];
}

- (NSString *)join:(NSString *)delimiter
{
	if ( 0 == self.count )
	{
		return @"";
	}
	else if ( 1 == self.count )
	{
		return [[self objectAtIndex:0] asNSString];
	}
	else
	{
		NSMutableString * result = [NSMutableString string];
		
		for ( NSUInteger i = 0; i < self.count; ++i )
		{
			[result appendString:[[self objectAtIndex:i] asNSString]];
			
			if ( i + 1 < self.count )
			{
				[result appendString:delimiter];
			}
		}
		
		return result;
	}
}

@end

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

#pragma mark -

@implementation NSMutableArray(BeeExtension)

@dynamic APPEND;

- (NSMutableArrayAppendBlock)APPEND
{
	NSMutableArrayAppendBlock block = ^ NSMutableArray * ( id obj )
	{
		[self addObject:obj];
		return self;
	};
	
	return BEE_AUTORELEASE([block copy]);
}

+ (NSMutableArray *)nonRetainingArray	// copy from Three20
{
	CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
	callbacks.retain = __TTRetainNoOp;
	callbacks.release = __TTReleaseNoOp;
	return BEE_AUTORELEASE((NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable( nil, 0, &callbacks )));
}

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare
{
	BOOL found = NO;
	
	for ( id obj in self )
	{
		if ( compare )
		{
			NSComparisonResult result = compare( obj, object );
			if ( NSOrderedSame == result )
			{
				found = YES;
				break;
			}
		}
		else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
		{
			NSComparisonResult result = [obj compare:object];
			if ( NSOrderedSame == result )
			{
				found = YES;
				break;
			}
		}
	}
	
	if ( NO == found )
	{
		[self addObject:object];
	}
}

- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSMutableArrayCompareBlock)compare
{
	for ( int i = 0; i < count; ++i )
	{
		BOOL	found = NO;
		id		object = objects[i];

		for ( id obj in self )
		{
			if ( compare )
			{
				NSComparisonResult result = compare( obj, object );
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
			else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
			{
				NSComparisonResult result = [obj compare:object];
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
		}

		if ( NO == found )
		{
			[self addObject:object];
		}
	}
}

- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSMutableArrayCompareBlock)compare
{
	for ( id object in array )
	{
		BOOL found = NO;

		for ( id obj in self )
		{
			if ( compare )
			{
				NSComparisonResult result = compare( obj, object );
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
			else if ( [obj class] == [object class] && [obj respondsToSelector:@selector(compare:)] )
			{
				NSComparisonResult result = [obj compare:object];
				if ( NSOrderedSame == result )
				{
					found = YES;
					break;
				}
			}
		}
		
		if ( NO == found )
		{
			[self addObject:object];
		}
	}
}

- (NSMutableArray *)pushHead:(NSObject *)obj
{
	if ( obj )
	{
		[self insertObject:obj atIndex:0];
	}
	
	return self;
}

- (NSMutableArray *)pushHeadN:(NSArray *)all
{
	if ( [all count] )
	{	
		for ( NSUInteger i = [all count]; i > 0; --i )
		{
			[self insertObject:[all objectAtIndex:i - 1] atIndex:0];
		}
	}
	
	return self;
}

- (NSMutableArray *)popTail
{
	if ( [self count] > 0 )
	{
		[self removeObjectAtIndex:[self count] - 1];
	}
	
	return self;
}

- (NSMutableArray *)popTailN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = n;
			range.length = [self count] - n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)pushTail:(NSObject *)obj
{
	if ( obj )
	{
		[self addObject:obj];		
	}
	
	return self;
}

- (NSMutableArray *)pushTailN:(NSArray *)all
{
	if ( [all count] )
	{
		[self addObjectsFromArray:all];		
	}
	
	return self;
}

- (NSMutableArray *)popHead
{
	if ( [self count] )
	{
		[self removeLastObject];
	}
	
	return self;
}

- (NSMutableArray *)popHeadN:(NSUInteger)n
{
	if ( [self count] > 0 )
	{
		if ( n >= [self count] )
		{
			[self removeAllObjects];
		}
		else
		{
			NSRange range;
			range.location = 0;
			range.length = n;
			
			[self removeObjectsInRange:range];
		}
	}
	
	return self;
}

- (NSMutableArray *)keepHead:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = n;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (NSMutableArray *)keepTail:(NSUInteger)n
{
	if ( [self count] > n )
	{
		NSRange range;
		range.location = 0;
		range.length = [self count] - n;
		
		[self removeObjectsInRange:range];		
	}
	
	return self;
}

- (void)insertObjectNoRetain:(id)object atIndex:(NSUInteger)index
{
	[self insertObject:object atIndex:index];
    BEE_RELEASE(object);

}

- (void)addObjectNoRetain:(NSObject *)object
{
	[self addObject:object];
    BEE_RELEASE(object);
}

- (void)removeObjectNoRelease:(NSObject *)object
{

    BEE_RELEASE(object);
	[self removeObject:object];
}

- (void)removeAllObjectsNoRelease
{
	for ( NSObject * object in self )
	{
        BEE_RETAIN(object);
	}	
	
	[self removeAllObjects];
}

- (NSMutableArray *)removeDataWithTimeInterval:(CGFloat)timeInterval {
    if (nil == self || 0 == self.count) {
        return self;
    }
    double nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *ary =[[NSMutableArray alloc] initWithArray:self];
    for(id obj in self) {
        if ([obj respondsToSelector:@selector(createTime)]) {
            NSString *time = [obj performSelector:@selector(createTime)];
            NSDate *date = [NSDate dateFromString:time];
            CGFloat createInterval = [date timeIntervalSince1970];
            if (createInterval + timeInterval < nowTimeInterval) {
                [ary removeObject:obj];
            }
        }
    }
    return ary;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSArray_BeeExtension )
{
	TIMES( 3 )
	{
		NSArray * arr = [NSArray array];
		EXPECTED( arr );
		EXPECTED( 0 == arr.count );
		
		NSString * temp = [arr safeObjectAtIndex:100];
		EXPECTED( nil == temp );
		
		arr = arr.APPEND( @"1" );
		EXPECTED( 1 == arr.count );
		
		arr = arr.APPEND( @"2" ).APPEND( @"3" );
		EXPECTED( 3 == arr.count );
		
		NSArray * head2 = [arr head:2];
		EXPECTED( head2 );
		EXPECTED( 2 == head2.count );
		EXPECTED( [[head2 objectAtIndex:0] isEqualToString:@"1"] );
		EXPECTED( [[head2 objectAtIndex:1] isEqualToString:@"2"] );
		
		NSArray * tail2 = [arr tail:2];
		EXPECTED( tail2 );
		EXPECTED( 2 == tail2.count );
		EXPECTED( [[tail2 objectAtIndex:0] isEqualToString:@"2"] );
		EXPECTED( [[tail2 objectAtIndex:1] isEqualToString:@"3"] );
	}
}
TEST_CASE_END

TEST_CASE( NSMutableArray_BeeExtension )
{
	//	+ (NSMutableArray *)nonRetainingArray;	// copy from Three20
	//
	//	- (NSMutableArray *)pushHead:(NSObject *)obj;
	//	- (NSMutableArray *)pushHeadN:(NSArray *)all;
	//	- (NSMutableArray *)popTail;
	//	- (NSMutableArray *)popTailN:(NSUInteger)n;
	//
	//	- (NSMutableArray *)pushTail:(NSObject *)obj;
	//	- (NSMutableArray *)pushTailN:(NSArray *)all;
	//	- (NSMutableArray *)popHead;
	//	- (NSMutableArray *)popHeadN:(NSUInteger)n;
	//
	//	- (NSMutableArray *)keepHead:(NSUInteger)n;
	//	- (NSMutableArray *)keepTail:(NSUInteger)n;
	//
	//	- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
	//	- (void)addObjectNoRetain:(NSObject *)obj;
	//	- (void)removeObjectNoRelease:(NSObject *)obj;
	//	- (void)removeAllObjectsNoRelease;
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__



