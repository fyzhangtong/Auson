//
//  UIView+ZTCAAnimation.h

//
//  Created by zhangtong on 2020/7/20.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZTCAAnimation)

- (void)addLikeAnimatrion;
- (void)addOverTurnAnimationWithHalfTimeBlock:(dispatch_block_t)halfTimeBlock;

@end

NS_ASSUME_NONNULL_END
