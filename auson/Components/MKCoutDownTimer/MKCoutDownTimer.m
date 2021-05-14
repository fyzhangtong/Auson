//
//  MKGCDTimer.m
//  Timer
//
//  Created by make on 2018/5/23.
//  Copyright © 2018年 make. All rights reserved.
//

#import "MKCoutDownTimer.h"

@interface MKCoutDownTimer()
@property (nonatomic, strong)dispatch_source_t timer;
@end

@implementation MKCoutDownTimer


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configSource];
    }
    return self;
}

- (void)configSource{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
}


+(MKCoutDownTimer *)timerWithCountdownTime:(NSTimeInterval)sec rate:(float)rate executeBlock:(timerBlock)block endBlock:(endBlock)endBlock {
    
    MKCoutDownTimer *gcdTimer = [[MKCoutDownTimer alloc]init];

    // rate秒执行一次
    dispatch_source_set_timer(gcdTimer.timer, dispatch_walltime(NULL, 0), rate * NSEC_PER_SEC, 0);
    
    //对比时间
    NSTimeInterval seconds = sec;
    
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds]; // 最后期限
    
    dispatch_source_set_event_handler(gcdTimer.timer, ^{
        
        int interval = [endTime timeIntervalSinceNow];
        
        if (interval > 0) { // 更新倒计时
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    block(interval);
                }
                
            });
        } else { // 倒计时结束，关闭
            
            dispatch_source_cancel(gcdTimer.timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (endBlock) {
                    endBlock();
                }
                
            });
        }
    });
    
    dispatch_resume(gcdTimer.timer);
    
    return gcdTimer;
}

+(MKCoutDownTimer *)timerWithCountdownTime:(NSTimeInterval)sec rate:(float)rate progressBlock:(void(^)(CGFloat progress))block endBlock:(endBlock)endBlock {
    
    MKCoutDownTimer *gcdTimer = [[MKCoutDownTimer alloc]init];

    // rate秒执行一次
    dispatch_source_set_timer(gcdTimer.timer, dispatch_walltime(NULL, 0), rate * NSEC_PER_SEC, 0);
    
    //对比时间
    NSDate *startTime = [NSDate date];
    dispatch_source_set_event_handler(gcdTimer.timer, ^{
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startTime];
        
        if (interval < sec) { // 更新倒计时
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (block) {
                    
                    block(interval/sec);
                }
                
            });
        } else { // 倒计时结束，关闭
            
            dispatch_source_cancel(gcdTimer.timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (endBlock) {
                    endBlock();
                }
                
            });
        }
    });
    
    dispatch_resume(gcdTimer.timer);
    
    return gcdTimer;
}

//计时
+(MKCoutDownTimer *)timerWithCountWithRate:(float)rate executeBlock:(timerBlock)block {
    
    MKCoutDownTimer *gcdTimer = [[MKCoutDownTimer alloc]init];
    
    dispatch_source_set_timer(gcdTimer.timer, dispatch_walltime(NULL, 0), rate * NSEC_PER_SEC, 0);
    
    NSTimeInterval beginTime = [NSDate date].timeIntervalSince1970;
    
    dispatch_source_set_event_handler(gcdTimer.timer, ^{
        int interval =  [NSDate date].timeIntervalSince1970 - beginTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            block(interval);
        });
    });
    
    dispatch_resume(gcdTimer.timer);
    
    return gcdTimer;
}

//销毁定时器
- (void)invalidate{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

@end
