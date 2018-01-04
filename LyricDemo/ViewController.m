//
//  ViewController.m
//  LyricDemo
//
//  Created by Perfect on 2018/1/3.
//  Copyright © 2018年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "Lyric.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lyricLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextLyricLabel;
@property (nonatomic) NSInteger lyricIndex;
@property (nonatomic) NSInteger nextLyricIndex;
@property (nonatomic, strong) NSArray *lyrics;

@property (nonatomic) float currentTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.lyricIndex = 0;
    self.currentTime = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checking) userInfo:nil repeats:YES];
}

- (void)checking {
    
    // 是否已超過最後一句歌詞結束時間：
    Lyric *lastLyric = [self.lyrics lastObject];
    if(self.currentTime > lastLyric.endTime){
        return;
    }
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%.2f", self.currentTime];
    self.currentTime = self.currentTime + 0.4;
    /*
     每句歌詞流程必定是：NotInSchedule - UpComing - Playing - NotInSchedule，前兩流程不一定會有。
     檢查目前歌詞狀態：
     1. 播放中，現在時間處於目前歌詞開始至結束之間：
        i.目前歌詞狀態即為播放中，檢查下一句歌詞狀態，是否在三秒內會出現，是的話改變下一句歌詞Label，否的話設置下一句歌詞Label為not available。
        ii.目前歌詞狀態不是播放中（即正從即將出現轉為播放中），將狀態改為播放中，改變目前歌詞Label，將nextLyricIndex＋1。
     2. 即將出現，現在時間處於目前歌詞開始前3秒：目前歌詞時間未到，目前歌詞Label為空，下句歌詞index等於目前歌詞index，設置下句歌詞為目前歌詞
     3. 播畢，現在時間已超過目前歌詞結束時間：狀態設為播畢，改變目前歌詞Label為空，目前index＋1，
    **/
    
    Lyric *lyric = self.lyrics[self.lyricIndex];
    switch ([lyric statusByTime:self.currentTime]) {
        case LyricStatusPlaying:
        {
            if(lyric.currentStatus != LyricStatusPlaying){
                lyric.currentStatus = LyricStatusPlaying;
                [self lyricLabelWithValue:YES];
                self.nextLyricIndex = self.lyricIndex + 1;
            }
            Lyric *nextLyric = self.lyrics[self.nextLyricIndex];

            if([nextLyric statusByTime:self.currentTime] == LyricStatusUpcoming){
                [self nextLyricLabelWithValue:YES];
            }else {
                [self nextLyricLabelWithValue:NO];
            }
        }
            break;
        case LyricStatusUpcoming:
            if(lyric.currentStatus != LyricStatusUpcoming){
                lyric.currentStatus = LyricStatusUpcoming;
                [self lyricLabelWithValue:NO];
                self.nextLyricIndex = self.lyricIndex;
                [self nextLyricLabelWithValue:YES];
            }
            break;
        case LyricStatusNotInSchedule:
            lyric.currentStatus = LyricStatusNotInSchedule;
            [self lyricLabelWithValue:NO];
            self.lyricIndex ++;
            break;
    }
}

#pragma mark - Tool
- (void)lyricLabelWithValue:(BOOL)available {
    Lyric *lyric = self.lyrics[self.lyricIndex];
    self.lyricLabel.text = available ? lyric.text : @"not available";
}

- (void)nextLyricLabelWithValue:(BOOL)available {
    Lyric *nextLyric = self.lyrics[self.nextLyricIndex];
    self.nextLyricLabel.text = available ? nextLyric.text : @"not available";
}

#pragma mark - Data prep
- (void)setLyricIndex:(NSInteger)lyricIndex {
    if(lyricIndex < self.lyrics.count){
        _lyricIndex = lyricIndex;
    }
}

- (void)setNextLyricIndex:(NSInteger)nextLyricIndex {
    if(nextLyricIndex < self.lyrics.count){
        _nextLyricIndex = nextLyricIndex;
    }
}

- (NSArray *)lyrics {
    if(!_lyrics){
        Lyric *l1 = [[Lyric alloc] init];
        l1.startTime = 0;
        l1.endTime = 5;
        l1.text = @"0~5";
        
        Lyric *l11 = [[Lyric alloc] init];
        l11.startTime = 6;
        l11.endTime = 7;
        l11.text = @"6~7";
        
        Lyric *l2 = [[Lyric alloc] init];
        l2.startTime = 11;
        l2.endTime = 13;
        l2.text = @"11~13";
        
        Lyric *l3 = [[Lyric alloc] init];
        l3.startTime = 14;
        l3.endTime = 17;
        l3.text = @"14~17";
 
        _lyrics = @[l1, l11, l2, l3];
    }
    return _lyrics;
}

@end
