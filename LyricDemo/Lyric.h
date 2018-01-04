//
//  Lyric.h
//  LyricDemo
//
//  Created by Perfect on 2018/1/3.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LyricStatus){
    LyricStatusNotInSchedule = 0,
    LyricStatusPlaying,
    LyricStatusUpcoming
};

@interface Lyric : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval endTime;
@property (nonatomic) LyricStatus currentStatus;
- (LyricStatus)statusByTime:(float)time;

@end
