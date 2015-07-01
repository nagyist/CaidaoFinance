//
//  GZMessUtils.m
//  ForeignLanguage
//
//  Created by ZhuWeijie on 14-7-25.
//  Copyright (c) 2014年 zwj. All rights reserved.
//

#import "GZMessUtils.h"


@implementation GZMessUtils

+(GZMessUtils*)sharedUtils
{
    static GZMessUtils * sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


-(void)showDarkMask:(UIView *)view delegate:(id<GZMessUtilsDelegate>)delegate
{
    if (!_dview) {
        _dview =[[UIView alloc] initWithFrame:view.frame];
        _dview.backgroundColor = RGBAlpha(0, 0, 0, 0.7);
        [view addSubview:_dview];
        
        self.delegate = delegate;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_dview addGestureRecognizer:tap];
    }
}

-(void)removeDarkMask
{
    [_dview removeFromSuperview];
    _dview = nil;
}

#pragma mark CountDown
-(void)startCountDown:(NSInteger)time label:(UILabel *)label block:(void (^)())block
{
    __block int timeout=time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [label setText:@"获取验证码"];
                if (block) {
                    block();
                }
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                label.text = [NSString stringWithFormat:@"%@s后获取",strTime];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

}


-(void)tapAction:(UIGestureRecognizer*)gesture
{
    if ([_delegate respondsToSelector:@selector(didTapOnDarkView)]) {
        [_dview removeFromSuperview];
        _dview = nil;
        [self.delegate didTapOnDarkView];
    }
}

@end
