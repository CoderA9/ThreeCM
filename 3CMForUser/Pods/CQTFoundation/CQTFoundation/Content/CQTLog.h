//
//  CQTLog.h
//  CQTIda
//
//  Created by ANine on 5/28/14.
//  Copyright (c) 2014 www.cqtimes.com. All rights reserved.
//

#define CQT_LOGLEVEL_DEBUG    7
#define CQT_LOGLEVEL_INFO     5
#define CQT_LOGLEVEL_WARNING  3
#define CQT_LOGLEVEL_ERROR    1
#define CQT_LOGLEVEL_NONE     0
#if DEBUG

#define CQT_MAX_LOGLEVEL       CQT_LOGLEVEL_DEBUG

#else

#define CQT_MAX_LOGLEVEL       CQT_LOGLEVEL_INFO

#endif

//TODO:TOA9上线时设置为CQT_LOGLEVEL_NONE,不打印任何Log.
// define Log Level
#ifndef CQT_MAX_LOGLEVEL

#define CQT_MAX_LOGLEVEL CQT_LOGLEVEL_DEBUG

#endif


#define CQTLogCurrentMethod CQTDebugLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))

#define CQTDPRINT(s, level , ...)  NSLog(@"%@\t%s(%d): " s, level ,__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define CQTDebugLog(s, ...) { \
if (CQT_LOGLEVEL_DEBUG <= CQT_MAX_LOGLEVEL) { \
CQTDPRINT(s, @"DEBUG", ##__VA_ARGS__); \
} \
}((void)0)

#define CQTInfoLog(s, ...) { \
if (CQT_LOGLEVEL_INFO <= CQT_MAX_LOGLEVEL) { \
CQTDPRINT(s, @"INFO", ##__VA_ARGS__); \
} \
}((void)0)

#define CQTWarnLog(s, ...) { \
if (CQT_LOGLEVEL_WARNING <= CQT_MAX_LOGLEVEL) { \
CQTDPRINT(s, @"WARN", ##__VA_ARGS__); \
} \
}((void)0)

#define CQTErrorLog(s, ...) { \
if (CQT_LOGLEVEL_ERROR <= CQT_MAX_LOGLEVEL) { \
CQTDPRINT(s, @"ERROR", ##__VA_ARGS__); \
} \
}((void)0)

