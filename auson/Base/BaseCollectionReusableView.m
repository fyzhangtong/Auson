//
//  BaseCollectionReusableView.m
//  FanBookClub
//
//  Created by zhangtong on 2020/5/19.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "BaseCollectionReusableView.h"

@implementation BaseCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeView];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}
+ (void)registerCollectionView:(UICollectionView *)collectionView kind:(nonnull NSString *)kind
{
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:kind withReuseIdentifier:[self reuseIdentifier]];
}
+ (CGSize)cellSize
{
    return CGSizeZero;
}

- (void)makeView
{
}

@end
