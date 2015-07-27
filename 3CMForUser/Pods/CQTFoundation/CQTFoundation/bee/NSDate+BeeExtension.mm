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

#import "NSDate+BeeExtension.h"

#import "Bee_UnitTest.h"
#import "NSNumber+BeeExtension.h"
#import "CQTGlobalConstants.h"
// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDate(BeeExtension)

@dynamic year;
@dynamic month;
@dynamic day;
@dynamic hour;
@dynamic minute;
@dynamic second;
@dynamic weekday;

- (NSDate *)dateFromString:(NSString *)dateString {
   return [NSDate dateFromString:dateString];
}
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [dateFormatter setTimeZone:timeZone];
    
    CQT_RELEASE(timeZone);
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    A9_ObjectReleaseSafely(dateFormatter);
    
    if (!destDate) {
        
        NSTimeInterval interval = [dateString floatValue];
        
       destDate = [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    return destDate;
    
}
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    A9_ObjectReleaseSafely(dateFormatter);
    
    return destDateString;
}
- (NSString *)stringFromDate:(NSDate *)date{
    
    return [NSDate stringFromDate:date];
}

- (NSInteger)year
{
	return [[NSCalendar currentCalendar] components:NSYearCalendarUnit
										   fromDate:self].year;
}

- (NSInteger)month
{
	return [[NSCalendar currentCalendar] components:NSMonthCalendarUnit
										   fromDate:self].month;
}

- (NSInteger)day
{
	return [[NSCalendar currentCalendar] components:NSDayCalendarUnit
										   fromDate:self].day;
}

- (NSInteger)hour
{
	return [[NSCalendar currentCalendar] components:NSHourCalendarUnit
										   fromDate:self].hour;
}

- (NSInteger)minute
{
	return [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit
										   fromDate:self].minute;
}

- (NSInteger)second
{
	return [[NSCalendar currentCalendar] components:NSSecondCalendarUnit
										   fromDate:self].second;
}

- (NSInteger)weekday
{
	return [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit
										   fromDate:self].weekday;
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
	
	NSTimeInterval time = [self timeIntervalSince1970];
	NSUInteger timeUint = (NSUInteger)time;
	return [[NSNumber numberWithUnsignedInteger:timeUint] stringWithDateFormat:format];
	
#else
	
	// thansk @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
	
	NSDateFormatter * dateFormatter = CQT_AUTORELEASE([[NSDateFormatter alloc] init]);
	[dateFormatter setDateFormat:format];
	return [dateFormatter stringFromDate:self];
	
#endif
}

- (NSString *)timeAgo
{
	NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
	if (delta < 1 * MINUTE)
	{
		return @"刚刚";
	}
	else if (delta < 2 * MINUTE)
	{
//        return @"刚刚";
		return @"1分钟前";
	}
	else if (delta < 45 * MINUTE)
	{
		int minutes = floor((double)delta/MINUTE);
		return [NSString stringWithFormat:@"%d分钟前", minutes];
	}
	else if (delta < 90 * MINUTE)
	{
		return @"1小时前";
	}
	else if (delta < 24 * HOUR)
	{
		int hours = floor((double)delta/HOUR);
		return [NSString stringWithFormat:@"%d小时前", hours];
	}
	else if (delta < 48 * HOUR)
	{
		return @"昨天";
	}
	else if (delta < 30 * DAY)
	{
		int days = floor((double)delta/DAY);
		return [NSString stringWithFormat:@"%d天前", days];
	}
	else if (delta < 12 * MONTH)
	{
		int months = floor((double)delta/MONTH);
		return months <= 1 ? @"1个月前" : [NSString stringWithFormat:@"%d个月前", months];
	}

	int years = floor((double)delta/MONTH/12.0);
	return years <= 1 ? @"1年前" : [NSString stringWithFormat:@"%d年前", years];
}

- (NSString *)timeDay {
    
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
	
    NSTimeInterval daySurlusInterval = 24 * HOUR - self.hour * HOUR - self.minute * MINUTE - self.second;
    
    
	if (delta < daySurlusInterval)
	{
		return [NSString stringWithFormat:@"今天 %ld:%ld",self.hour,self.minute];
	}
	else if (delta < ( 24 * HOUR + daySurlusInterval ) )
	{
		return [NSString stringWithFormat:@"昨天 %ld:%ld",self.hour,self.minute];;
	}

	return [NSString stringWithFormat:@"%ld-%ld-%ld",self.year, self.month,self.day];
}


- (NSString *)timeLeft
{
	long int delta = lround( [self timeIntervalSinceDate:[NSDate date]] );
    
    NSMutableString * result = [NSMutableString string];
    
    if ( delta >= YEAR )
    {
        long int years = ( delta / YEAR );
        [result appendFormat:@"%ld年", years];
        delta -= years * YEAR ;
    }
    
	if ( delta >= MONTH )
	{
        long int months = ( delta / MONTH );
        [result appendFormat:@"%ld月", months];
        delta -= months * MONTH ;
	}
    
    if ( delta >= DAY )
    {
        long int days = ( delta / DAY );
        [result appendFormat:@"%ld天", days];
        delta -= days * DAY ;
    }
    
    if ( delta >= HOUR )
    {
        long int hours = ( delta / HOUR );
        [result appendFormat:@"%ld小时", hours];
        delta -= hours * HOUR ;
    }
    
    if ( delta >= MINUTE )
    {
        long int minutes = ( delta / MINUTE );
        [result appendFormat:@"%ld分钟", minutes];
        delta -= minutes * MINUTE ;
    }
    
//    if ( delta >= SECOND )
    {
        long int seconds = ( delta / SECOND );
        [result appendFormat:@"%ld秒", seconds];
    }

	return result;
}

+ (long long)timeStamp
{
	return (long long)[[NSDate date] timeIntervalSince1970];
}

+ (NSDate *)dateWithString:(NSString *)string
{
    return nil;
}

+ (NSDate *)now
{
	return [NSDate date];
}



/* 通过一个时间戳,获取小时以下的数据. */
+ (NSString *)getBelowDayTimeInterval:(NSTimeInterval)interval {
    
    int hour = ((long long)interval % (24 * 60 *60) )/ (60 * 60);
    int min = ((long long)interval % (60 *60) ) / 60;
    int second = (long long)interval % 60;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    hour = date.hour;
    
    min = date.minute;
    
    second = date.second;
    
    interval = hour * 60 * 60 + min * 60 + second ;
    
    return [NSString stringWithFormat:@"%f",interval];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( NSDate_BeeExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__
