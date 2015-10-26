//
//  TouchPassViewController.m
//  
//
//  Created by MBP on 15/7/8.
//
//

#import "TouchPassViewController.h"
#import "YLSwipeLockView.h"

@interface TouchPassViewController ()<YLSwipeLockViewDelegate>
{
    NSString * passString;
}
@end

@implementation TouchPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    if ([password isEqualToString:[USER_DEFAULT objectForKey:TOUCH_PASS]])
    {
        passString = nil;
        _passTitle.text = @"手势密码输入正确";
        [[[UIApplication sharedApplication] keyWindow].rootViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        return YLSwipeLockViewStateSelected;
    }
    else
    {
        _passTitle.text = @"手势密码输入错误";
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

@end
