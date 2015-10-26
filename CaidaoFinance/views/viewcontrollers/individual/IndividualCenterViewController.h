//
//  IndividualCenterViewController.h
//  
//
//  Created by MBP on 15/7/28.
//
//

#import <UIKit/UIKit.h>

@interface IndividualCenterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UILabel *zongjine;
@property (weak, nonatomic) IBOutlet UILabel *keyongjine;
@property (weak, nonatomic) IBOutlet UILabel *redpackage;
@property (weak, nonatomic) IBOutlet UILabel *jifen;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)photoAction:(id)sender;
- (IBAction)infoAction:(id)sender;
- (IBAction)buttonAction:(id)sender;
@end
