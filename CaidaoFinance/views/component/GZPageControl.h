//
//  GZPageControl.h
//  GZPageControl
//
//  Created by zhuweijie on 14-8-18.
//  Copyright (c) 2014 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GZPageControlAlignment) {
	GZPageControlAlignmentLeft = 1,
	GZPageControlAlignmentCenter,
	GZPageControlAlignmentRight
};

typedef NS_ENUM(NSUInteger, GZPageControlVerticalAlignment) {
	GZPageControlVerticalAlignmentTop = 1,
	GZPageControlVerticalAlignmentMiddle,
	GZPageControlVerticalAlignmentBottom
};

@interface GZPageControl : UIControl

@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) CGFloat indicatorMargin							UI_APPEARANCE_SELECTOR;
@property (nonatomic) CGFloat indicatorDiameter							UI_APPEARANCE_SELECTOR;
@property (nonatomic) GZPageControlAlignment alignment					UI_APPEARANCE_SELECTOR;
@property (nonatomic) GZPageControlVerticalAlignment verticalAlignment	UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIImage *pageIndicatorImage				UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor			UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *currentPageIndicatorImage		UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor	UI_APPEARANCE_SELECTOR;

@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic) BOOL defersCurrentPageDisplay;

- (void)updateCurrentPageDisplay;						// 更新当前显示对象

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex;    //获取对象所在值的frame
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex;
- (UIImage *)imageForPage:(NSInteger)pageIndex;
- (UIImage *)currentImageForPage:(NSInteger)pageIndex;

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView;

@end 
