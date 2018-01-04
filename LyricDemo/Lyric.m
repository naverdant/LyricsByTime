//
//  Lyric.m
//  LyricDemo
//
//  Created by Perfect on 2018/1/3.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "Lyric.h"

@implementation Lyric

- (LyricStatus)statusByTime:(float)time {
    if(time >= self.startTime && time <= self.endTime){
        return LyricStatusPlaying;
    }else if (time < self.startTime && time + 3 > self.startTime){
        return LyricStatusUpcoming;
    }else {
        return LyricStatusNotInSchedule;
    }
}

@end
