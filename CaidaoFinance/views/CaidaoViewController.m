//
//  CaidaoViewController.m
//  CaidaoFinance
//
//  Created by LJ on 15/5/5.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "CaidaoViewController.h"

@interface CaidaoViewController ()

@end

@implementation CaidaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)){
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
//    self.view.backgroundColor = RGBCOLOR(232, 232, 232);
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
