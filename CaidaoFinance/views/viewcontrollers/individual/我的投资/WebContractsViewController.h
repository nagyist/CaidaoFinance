//
//  WebContractsViewController.h
//  
//
//  Created by MBP on 15/7/6.
//
//

#import <UIKit/UIKit.h>

@interface WebContractsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithURL:(NSDictionary*)url;
@end
