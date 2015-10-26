//
//  GZMenuView.m
//  TestDropDownViewAutoLayout
//
//  Created by LJ on 15/5/11.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#define DEFAULT_VIEW_HEIGHT  40
#define MENU_ITEM_HEIGHT   20
#define MAX_MENU_HEIGHT    60
#define RGBCOLOR(r, g, b)        [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#import "GZMenuListView.h"
#import "Masonry.h"

@interface GZMenuListView ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView*bgImgView;
}


@property (nonatomic,strong)UIView * defaultView;
@property (nonatomic,strong)UILabel * defaultLable;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIImageView * arrowImage;
@property (nonatomic)BOOL isOpen;
@property (nonatomic)NSInteger selectedInt;

@end

@implementation GZMenuListView

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)initialize
{
    if (self != [GZMenuListView class])
        return;
    GZMenuListView*appearance = [self appearance];
    appearance.sepactorColor = [UIColor lightGrayColor];
    appearance.textFont = [UIFont systemFontOfSize:16];
    appearance.textNormalColor = [UIColor blackColor];
    appearance.textSelectedColor = [UIColor blackColor];
    appearance.defaultBgColor = [UIColor clearColor];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setup];
}


#pragma mark setup
-(void)setup
{
    [self setDefaultView];
    [self setTableView];
    [self invalidateLayout];
}

-(void)setDefaultView
{
    self.selectedIndex = 0;
    self.backgroundColor = [UIColor whiteColor];
    self.defaultView = [[UIView alloc] initWithFrame:self.bounds];
    self.defaultView.backgroundColor = self.defaultBgColor;
    [self addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@0);
         make.right.equalTo(@0);
         make.top.equalTo(@0);
         make.height.equalTo(self.mas_height);
     }];
    self.defaultLable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.defaultLable.textColor = [UIColor lightGrayColor];
    self.defaultLable.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:13];
    self.defaultLable.userInteractionEnabled = NO;
    self.defaultLable.text = self.placeStr;
    self.defaultLable.textAlignment = NSTextAlignmentLeft;
    [self.defaultView addSubview:self.defaultLable];
    
    [self.defaultLable mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(self.defaultView.mas_left).offset(15);
         make.right.equalTo(self.defaultView.mas_right).offset(-20);
         make.centerY.equalTo(self.defaultView.mas_centerY);
         make.height.equalTo(self.mas_height);
     }];
    
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.defaultView addGestureRecognizer:gesture];
    
    _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 32, 40)];
    [_arrowImage setImage:[UIImage imageNamed:@"lend_droplist_arrow_normal"]];
    [self addSubview:_arrowImage];
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(self.defaultLable.mas_right).offset(-20);
         make.width.equalTo(@33);
         make.centerY.equalTo(self.defaultLable);
         make.height.equalTo(@40);
         
     }];
    
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture
{
    NSLog(@"%i",self.isOpen);
    if (!self.isOpen) {
        [self open];
    }
    else
    {
        [self close];
    }
}

-(void)setTableView
{
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    
//    
//    bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [bgImgView setImage:[UIImage imageNamed:@"menu_list_bg"]];
//    [_menuSuperView insertSubview:bgImgView atIndex:[[_menuSuperView subviews] count] - 1];
//    [bgImgView mas_makeConstraints:^(MASConstraintMaker*make)
//     {
//         make.top.mas_equalTo(self.mas_top).offset(40);
//         make.left.mas_equalTo(self.mas_left).offset(0);
//         make.right.mas_equalTo(self.mas_right).offset(0);
//         make.height.equalTo(@0);
//     }];
//    bgImgView.image = [bgImgView.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, DEFAULT_VIEW_HEIGHT, self.frame.size.width, 20)];
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    [_tableView setShowsVerticalScrollIndicator:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = _sepactorColor;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }    [_menuSuperView insertSubview:_tableView atIndex:[[_menuSuperView subviews] count] - 1];
    

    [_tableView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.top.mas_equalTo(self.mas_top).offset(40);
         make.left.mas_equalTo(self.mas_left).offset(0);
         make.right.mas_equalTo(self.mas_right).offset(0);
         make.height.equalTo(@0);
     }];
}

#pragma mark tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*str = [_dataSource stringFromIndex:indexPath.row view:self];
    if ([_delegate respondsToSelector:@selector(didSelectedItem:value:tag:)]) {
        [_delegate didSelectedItem:indexPath value:str tag:self.tag];
    }
    [self close];
    [self changeValue:str];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
}

#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return MENU_ITEM_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource numberOfRowsOfview:self];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellId";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    GZMenuListItem*item = [[GZMenuListItem alloc] initWithText:[_dataSource stringFromIndex:indexPath.row view:self]];
    [cell addSubview:item];
    cell.backgroundColor = [UIColor clearColor];
    [item mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@0);
         make.right.equalTo(@0);
         make.top.equalTo(@0);
         make.bottom.equalTo(@0);
         
     }];
    return cell;
}

-(void)changeValue:(NSString*)value
{
    _defaultLable.text = value;
    
}


-(void)invalidateLayout
{
    
}

#pragma mark private
-(void)open
{
    [_arrowImage setImage:[UIImage imageNamed:@"lend_droplist_arrow_selected"]];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker*make)
    {
        make.top.mas_equalTo(self.mas_top).offset(self.frame.size.height);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(MAX_MENU_HEIGHT);
        
    }];
    
    _isOpen = YES;
}

-(void)close
{
    [_arrowImage setImage:[UIImage imageNamed:@"lend_droplist_arrow_normal"]];

    [_tableView mas_updateConstraints:^(MASConstraintMaker*make)
    {
        make.top.mas_equalTo(self.mas_top).offset(self.frame.size.height);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(0);
    }];
       _isOpen = NO;
}

@end

@interface GZMenuListItem ()

@property(nonatomic,strong)UILabel * text;
@property(nonatomic,strong)NSString * content;
@end
@implementation GZMenuListItem

+(void)initialize
{
    if (self != [GZMenuListItem class]) {
        return;
    }
    GZMenuListItem*item = [self appearance];
    item.itemBgColor = [UIColor whiteColor];
    item.itemBgImg = UIIMAGE(@"individual_menu_item_bg");
    item.itemSelectedBg = [UIColor grayColor];
    item.itemSelectedImg = nil;
    item.itemTextFont = [UIFont systemFontOfSize:14];
    item.itemTextColor = [UIColor blackColor];
}

-(id)initWithText:(NSString *)text
{
    self = [super init];
    if(self){
        self.content = text;
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectZero];
    bg.image = self.itemBgImg;
    bg.image = UIIMAGE(@"individual_menu_item_bg");
    [self addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.centerY.equalTo(@0);
         make.centerX.equalTo(@0);
         make.width.equalTo(self.mas_width);
         make.height.equalTo(self.mas_height);
     }];
    
    self.backgroundColor = [UIColor clearColor];
    self.text = [[UILabel alloc] initWithFrame:CGRectZero];
    self.text.textColor = RGBCOLOR(167, 52, 49);
    self.text.textAlignment = NSTextAlignmentLeft;
    self.text.font = [UIFont fontWithName:@"HiraginoSansGB-W3" size:13];
    self.text.text = self.content;
    self.text.backgroundColor = [UIColor clearColor];
    [self addSubview:self.text];
    [self.text mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.centerY.equalTo(self);
         make.left.equalTo(@10);
//         make.centerX.equalTo(self);
     }];
}

@end





