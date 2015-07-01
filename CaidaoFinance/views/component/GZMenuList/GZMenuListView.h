//
//  GZMenuView.h
//  TestDropDownViewAutoLayout
//
//  Created by LJ on 15/5/11.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GZMenuListViewDelegate <NSObject>
-(void)didSelectedItem:(NSIndexPath*)indexPath value:(NSString*)value;
@end

@protocol GZMenuListViewDataSource;
@interface GZMenuListView : UIView

@property(nonatomic,strong)UIColor * defaultBgColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIFont * textFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * textNormalColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * textSelectedColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * sepactorColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIImage * arrowImg NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;


@property(nonatomic,strong)id<GZMenuListViewDataSource>dataSource;
@property(nonatomic,strong)id<GZMenuListViewDelegate>delegate;

@property(nonatomic,strong)UIView * menuSuperView;
@property(nonatomic,strong)UIImage * bgImg;
////初始化
-(id)init;

+(void)initialize;
@end

@protocol GZMenuListViewDataSource <NSObject>

-(NSString*)stringFromIndex:(NSInteger)index view:(GZMenuListView*)menuView;

-(NSInteger)numberOfRowsOfview:(GZMenuListView*)menuView;

@end

@interface GZMenuListItem : UIView

@property(nonatomic,strong)UIFont * itemTextFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * itemBgColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIImage * itemBgImg NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * itemSelectedBg NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIImage * itemSelectedImg NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,strong)UIColor * itemTextColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

-(id)initWithText:(NSString*)text;

@end