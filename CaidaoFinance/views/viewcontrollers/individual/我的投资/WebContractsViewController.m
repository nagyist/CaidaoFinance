//
//  WebContractsViewController.m
//  
//
//  Created by MBP on 15/7/6.
//
//

#import "WebContractsViewController.h"

@interface WebContractsViewController () {
    NSString * webURL;
    NSString * title;
}

@end

@implementation WebContractsViewController

- (id)initWithURL:(NSDictionary *)url {
    if (self) {
        webURL = [url objectForKey:@"url"];
        title = [url objectForKey:@"name"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = title;
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webURL]]];
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
