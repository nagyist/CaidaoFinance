//
//  SecurityViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "SecurityViewController.h"

@interface SecurityViewController ()
{
    NSDictionary * detailData;

}
@end

@implementation SecurityViewController

- (id)initWithDetailData:(NSDictionary *)data
{
    if (self) {
        detailData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * htmlString = [[detailData objectForKey:@"borrow"]objectForKey:@"borrowContent"];
    NSLog(@"保障模式:%@",htmlString);
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    self.text.attributedText = attrStr;
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
