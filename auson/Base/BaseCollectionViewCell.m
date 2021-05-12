//
//  BaseCollectionViewCell.m
//
//  Created by zhangtong on 2018/3/27.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell

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
+ (void)registerCell:(UICollectionView *)collectionView
{
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self reuseIdentifier]];
}
+ (CGSize)cellSize
{
    return CGSizeZero;
}

- (void)makeView
{
}


@end
