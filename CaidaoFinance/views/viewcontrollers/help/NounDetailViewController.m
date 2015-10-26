//
//  NounDetailViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/8.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "NounDetailViewController.h"

@interface NounDetailViewController ()
{
    NSString * contentDetail;
}

@end

@implementation NounDetailViewController

-(id)initWithContent:(NSString *)detail title:(NSString *)title
{
    if (self) {
        contentDetail = detail;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    _bgImg.image = [_bgImg.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];

    self.text.numberOfLines = 0;
    [self.text setText:contentDetail];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
