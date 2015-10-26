//
//  ZBarViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/6/3.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ZBarViewController.h"

@interface ZBarViewController ()<ZBarReaderViewDelegate>
{
    BOOL upOrdown;
}

@end

@implementation ZBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.readerView.readerDelegate = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lineAnimation) userInfo:nil repeats:YES];
    [self initScan];
    // Do any additional setup after loading the view from its nib.
}

-(void)initScan
{
    //不显示跟踪框
    _readerView.tracksSymbols = NO;
    //关闭闪关灯
    _readerView.torchMode = 0;
    //二维码拍摄的屏幕大小
    CGRect rvBounsRect = CGRectMake(0, 0, GZContent_Width, [UIScreen mainScreen].bounds.size.height);
    //二维码拍摄时，可扫描区域的大小
    CGRect scanCropRect = CGRectMake(0, 0, 320, 240);
    [self.readerView start];

    //设置ZBarReaderView的scanCrop属性
    _readerView.scanCrop = [self getScanCrop:scanCropRect readerViewBounds:rvBounsRect];
    //定时器使基准线闪动
}

//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat x,y,width,height;
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(x, y, width, height);
}


-(void)viewDidAppear:(BOOL)animated
{
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.readerView stop];
}

#pragma mark 处理扫描结果
- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    //处理扫描结果
    ZBarSymbol *sym =nil;
    for(sym in syms)
        break;
    //停止扫描
    [self.readerView stop];
    //移除红线
    [self.redLine removeFromSuperview];
}

#pragma mark 初始化扫描界面
-(void)lineAnimation
{
    float x = self.redLine.frame.origin.x;
    float y = self.redLine.frame.origin.y;
    float xSize = self.redLine.frame.size.width;
    if (upOrdown == NO) {
        self.redLine.frame = CGRectMake(x, y, xSize, 0.3);
        upOrdown = YES;
    }
    else {
        self.redLine.frame = CGRectMake(x, y, xSize, 0);
        upOrdown = NO;
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
