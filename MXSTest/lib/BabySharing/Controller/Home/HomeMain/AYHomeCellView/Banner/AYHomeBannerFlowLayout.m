//
//  CollectionViewFlowLayout.m
//  FocusCenterCollection
//
//  Created by Alfred Yang on 18/7/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "AYHomeBannerFlowLayout.h"

@implementation AYHomeBannerFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
	
	NSArray *attrs = [self deepCopyWithArray:[super layoutAttributesForElementsInRect:rect]];
	CGFloat contentOffsetX = self.collectionView.contentOffset.x;
	CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
	
	for (UICollectionViewLayoutAttributes *attr in attrs) {
		CGFloat scale_x = 1 - fabs(attr.center.x - contentOffsetX - collectionViewCenterX) / self.collectionView.bounds.size.width * 0.4;
		attr.transform = CGAffineTransformMakeScale(scale_x, scale_x);
	}
	return attrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}

//  每次都有图片居中

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//	
//	CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//	NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
//	
//	CGFloat contentOffsetX = self.collectionView.contentOffset.x;
//	CGFloat collectionViewCenterX = self.collectionView.frame.size.width * 0.5;
//	CGFloat minDistance = MAXFLOAT;
//	
//	for (UICollectionViewLayoutAttributes *attr in attrs) {
//		CGFloat distance = attr.center.x - contentOffsetX - collectionViewCenterX;
//		if (fabs(distance) < fabs(minDistance)) {
//			minDistance = distance;
//		}
//	}
//	proposedContentOffset.x += minDistance;
//	return proposedContentOffset;
//}

//  UICollectionViewFlowLayout has cached frame mismatch for index path这个警告来源主要是在使用layoutAttributesForElementsInRect：方法返回的数组时，没有使用该数组的拷贝对象，而是直接使用了该数组。解决办法对该数组进行拷贝，并且是深拷贝。

- (NSArray *)deepCopyWithArray:(NSArray *)arr {
	NSMutableArray *arrM = [NSMutableArray array];
	for (UICollectionViewLayoutAttributes *attr in arr) {
		[arrM addObject:[attr copy]];
	}
	return arrM;
}

@end
