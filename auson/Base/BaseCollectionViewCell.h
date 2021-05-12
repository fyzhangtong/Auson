//
//  BaseCollectionViewCell.h
//
//  Created by zhangtong on 2018/3/27.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;
+ (void)registerCell:(UICollectionView *)collectionView;
+ (CGSize)cellSize;

@end
