//
//  GoldLog.h
//  GoldLogFramework
//
//  Created by Micker on 15/12/8.
//  Copyright © 2015年 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger , GOLD_LOG_LEVEL_TYPE) {
    GOLD_LOG_LEVEL_TYPE_UNDEF = 0,
    GOLD_LOG_LEVEL_TYPE_DEBUG,
    GOLD_LOG_LEVEL_TYPE_INFO,
    GOLD_LOG_LEVEL_TYPE_WARN,
    GOLD_LOG_LEVEL_TYPE_ERROR,
    GOLD_LOG_LEVEL_TYPE_FATAL
};


#define LOG(lv,s,...)   [GoldLog GoldLog:lv file:__FILE__ lineNumber:__LINE__ func:__FUNCTION__ format:(s),##__VA_ARGS__]
#define DEBUGLOG(s,...) LOG(GOLD_LOG_LEVEL_TYPE_DEBUG,s,##__VA_ARGS__)
#define INFOLOG(s,...)  LOG(GOLD_LOG_LEVEL_TYPE_INFO,s,##__VA_ARGS__)
#define WARNLOG(s,...)  LOG(GOLD_LOG_LEVEL_TYPE_WARN,s,##__VA_ARGS__)
#define ERRLOG(s,...)   LOG(GOLD_LOG_LEVEL_TYPE_ERROR,s,##__VA_ARGS__)
#define FATALLOG(s,...) LOG(GOLD_LOG_LEVEL_TYPE_FATAL,s,##__VA_ARGS__)

#define FRAMELOG(rect) DEBUGLOG(@"frame = (%.2f,%.2f;%.2f,%.2f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#define SIZELOG(size)   DEBUGLOG(@"size = (%.2f,%.2f)", size.width, size.height);
#define POINTLOG(point) DEBUGLOG(@"point = (%.2f,%.2f)",point.x,point.y);


@interface GoldLog : NSObject

+ (void) startLevel:(GOLD_LOG_LEVEL_TYPE) leve;

/**
 * @brief format the log with Fun name and line
 *
 *
 * @param [in]  N/A    level        LOG level
 * @param [in]  N/A    sourceFile   file name
 * @param [in]  N/A    lineNumber   line number
 * @param [in]  N/A    funcName     fun name
 * @param [in]  N/A    format
 * @param [out] N/A
 * @return     void
 * @note
 */
+(void)GoldLog:(GOLD_LOG_LEVEL_TYPE)level
         file:(const char*)sourceFile
   lineNumber:(int)lineNumber
         func:(const char *)funcName
       format:(NSString*)format,...;
@end
