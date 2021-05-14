//
//  MKGCDTimer.h
//  Timer
//
//  Created by make on 2018/5/23.
//  Copyright © 2018年 make. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^endBlock)(void);
typedef void(^timerBlock)(int second);

@interface MKCoutDownTimer : NSObject


/**
 倒计时器，加入了对比系统时间

 @param sec 倒计时的总时间
 @param rate 频率（多少秒跑一次）
 @param block 在(主线程)
 @param endBlock 结束执行 （主线程）
 @return MKCoutDownTimer
 */
+(MKCoutDownTimer *)timerWithCountdownTime:(NSTimeInterval)sec rate:(float)rate executeBlock:(timerBlock)block endBlock:(endBlock)endBlock;

+(MKCoutDownTimer *)timerWithCountdownTime:(NSTimeInterval)sec rate:(float)rate progressBlock:(void(^)(CGFloat progress))block endBlock:(endBlock)endBlock;

- (void)invalidate;

/**
 计时

 @param rate 秒
 @param block block description
 @return return value description
 */
+(MKCoutDownTimer *)timerWithCountWithRate:(float)rate executeBlock:(timerBlock)block;
@end
