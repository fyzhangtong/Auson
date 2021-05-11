//
//  BaseCollectionViewCell.h
//  DolphinFinancial
//
//  Created by FDXDZ on 2018/3/27.
//  Copyright © 2018年 zhantong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;
+ (void)registerCell:(UICollectionView *)collectionView;
+ (CGSize)cellSize;

@end
