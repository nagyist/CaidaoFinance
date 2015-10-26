//
//  ActivityWebViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/6.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "ActivityWebViewController.h"
#import <MMMaterialDesignSpinner.h>


@interface ActivityWebViewController ()<UIWebViewDelegate>
{
    MMMaterialDesignSpinner *spinnerView;
    NSURL * mURL;
    NSString * titleStr;
    BOOL isXieyi;
    BOOL isAct;

}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ActivityWebViewController

- (id)initWithURL:(NSURL *)url
{
    if (self) {
        mURL = url;
        isXieyi = YES;
    }
    return self;
}

- (id)initWithURL:(NSURL *)url isActivity:(BOOL)activity {
    if (self) {
        mURL = url;
        isAct = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleStr = isXieyi?@"用户协议":@"活动";
    self.title = titleStr;
    spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinnerView.center = CGPointMake(self.view.center.x, self.view.center.y);
    spinnerView.lineWidth = 1.5f;
    spinnerView.tintColor = RGBCOLOR(247, 94, 37);
    [self.view addSubview:spinnerView];
    
    if (!mURL) {
        mURL = [NSURL URLWithString:@"http://www.baidu.com"];
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:mURL];
    
    [_webView loadRequest:request];
    _webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [spinnerView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [spinnerView stopAnimating];
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
