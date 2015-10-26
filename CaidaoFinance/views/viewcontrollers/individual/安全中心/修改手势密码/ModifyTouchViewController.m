//
//  ModifyTouchViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/26.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ModifyTouchViewController.h"
#import "YLSwipeLockView.h"
#import "LoginViewController.h"

@interface ModifyTouchViewController ()<YLSwipeLockViewDelegate>{
    NSString * passString;

}

@end

@implementation ModifyTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手势密码";
    YLSwipeLockView*lockView = [[YLSwipeLockView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lockView.delegate = self;
    _contentView.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:lockView];
    [lockView mas_makeConstraints:^(MASConstraintMaker*make)
     {
         make.left.equalTo(@0);
         make.right.equalTo(@0);
         make.top.equalTo(@0);
         make.bottom.equalTo(@0);
     }];
     
    // Do any additional setup after loading the view from its nib.
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    if (!passString) {
        passString = password;
        _passTitle.text = @"再次绘制解锁图案";
        return YLSwipeLockViewStateNormal;
    }
    else if ([password isEqualToString:passString])
    {
        passString = nil;
        _passTitle.text = @"设置成功";
        [USER_DEFAULT setObject:password forKey:TOUCH_PASS];
        _sureButton.hidden = NO;
        return YLSwipeLockViewStateSelected;
    }
    else
    {
        _passTitle.text = @"与上次绘制不一致，请重新绘制";
        return YLSwipeLockViewStateWarning;
    }
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

- (IBAction)sureAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)forgetAction:(id)sender {

    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}
@end
