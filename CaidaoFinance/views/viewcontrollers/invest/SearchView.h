//
//  SearchView.h
//  CaidaoFinance
//
//  Created by LJ on 15/5/15.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@protocol SearchViewDelegate <NSObject>

-(void)didSearch:(NSDictionary*)searchData;

@end
@interface SearchView : UIView


@property (nonatomic,strong)id<SearchViewDelegate>delegate;


@end
