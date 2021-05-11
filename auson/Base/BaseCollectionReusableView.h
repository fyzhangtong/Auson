//
//  BaseCollectionReusableView.h
//  FanBookClub
//
//  Created by zhangtong on 2020/5/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionReusableView : UICollectionReusableView

+ (NSString *)reuseIdentifier;
+ (void)registerCollectionView:(UICollectionView *)collectionView kind:(nonnull NSString *)kind;
+ (CGSize)cellSize;

@end

NS_ASSUME_NONNULL_END
