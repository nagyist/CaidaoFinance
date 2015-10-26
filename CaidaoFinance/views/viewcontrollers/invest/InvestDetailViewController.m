//
//  InvestDetailViewController.m
//  CaidaoFinance
//
//  Created by 朱玮杰 on 15/5/21.
//  Copyright (c) 2015年 zwj. All rights reserved.
//

#import "InvestDetailViewController.h"
#import "DetalViewController.h"
#import "SecurityViewController.h"
#import "CreditViewController.h"
#import "InvestRecordViewController.h"

@interface InvestDetailViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>{
    UIButton * lastSelectedButton;
    BOOL isPageToBounce;
    NSInteger _currentPage;
    NSArray * viewControllers;
    
    NSDictionary * detailData;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *pageContent;
@property (strong, nonatomic) NSMutableArray *buttons;
@end

@implementation InvestDetailViewController

- (id)initWithInvestDetailData:(NSDictionary *)data
{
    if (self) {
        detailData = data;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_buttonOne setSelected:YES];
    [_buttonOne setTintColor:[UIColor clearColor]];
    [_buttonTwo setTintColor:[UIColor clearColor]];
    [_buttonThree setTintColor:[UIColor clearColor]];
    [_buttonFour setTintColor:[UIColor clearColor]];

    
    lastSelectedButton = _buttonOne;
    [self initData];
    [self setupOpen];
   
    // Do any additional setup after loading the view from its nib.
}

-(void)initData{
    _buttons = [NSMutableArray new];
    [_buttons addObject:_buttonOne];
    [_buttons addObject:_buttonTwo];
    [_buttons addObject:_buttonThree];
    [_buttons addObject:_buttonFour];
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

- (void)scrollViewAtIndex:(NSInteger)index
{
    __weak UIPageViewController *weakSelf = self.pageController;
    UIViewController *viewController = viewControllers[index];
    [self.pageController setViewControllers:@[viewController]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:^(BOOL completed) {
                                         
                                         // Set the current page again to obtain synchronisation between tabs and content
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [weakSelf setViewControllers:@[viewController]
                                                                              direction:UIPageViewControllerNavigationDirectionReverse
                                                                               animated:NO
                                                                             completion:nil];
                                         });
                                     }];
    
}

-(void)setupOpen{
    DetalViewController*view = [[DetalViewController alloc] initWithDetailData:detailData];
    viewControllers = @[view,[[SecurityViewController alloc]initWithDetailData:detailData],[[CreditViewController alloc]initWithDetailData:detailData],[[InvestRecordViewController alloc]initWithDetailData:detailData]];
    self.pageContent = [NSMutableArray arrayWithArray:viewControllers];
    
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[_pageController view] setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    [_pageController setViewControllers:@[view]
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    for (UIView *view in self.pageController.view.subviews ) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView *)view;
            scroll.delegate = self;
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!isPageToBounce) {
        if (0 == _currentPage && scrollView.contentOffset.x < scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
        if (_currentPage == [_pageContent count]-1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    }

    // more
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (!isPageToBounce) {
        if (0 == _currentPage && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
            *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
        if (_currentPage == [_pageContent count]-1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
            *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    }
    
}


-(NSUInteger)indexForViewController:(UIViewController*)viewcontroller{
    return [_pageContent indexOfObject:viewcontroller];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexForViewController:viewController];
    _currentPage = index;
    [self setButtonSelected:index];
    lastSelectedButton  = _buttons[index];
    [self layoutScrollBar];
    index ++;
    return [self viewControllerAtIndex:index];
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexForViewController:viewController];
    _currentPage = index;
    [self setButtonSelected:index];
    lastSelectedButton  = _buttons[index];
    [self layoutScrollBar];
    index --;
    return [self viewControllerAtIndex:index];
}

// 得到相应的VC对象
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContent count] == 0) || (index >= [self.pageContent count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    return self.pageContent [index];
}

- (void)layoutScrollBar{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_scrollbar mas_updateConstraints:^(MASConstraintMaker*make){
             NSInteger x = lastSelectedButton.frame.origin.x;
             make.left.equalTo(@(x));
         }];
        [UIView animateWithDuration:0 animations:^(void){
             [self.view setNeedsLayout];
             [self.view layoutIfNeeded];
             [_scrollbar layoutIfNeeded];
         }];
    });
}

- (void)setButtonSelected:(NSInteger)index
{
    [(UIButton*)_buttons[index] setSelected:YES];
    [lastSelectedButton setSelected:NO];
}

- (IBAction)buttonAction:(id)sender {
    [sender setTintColor:[UIColor clearColor]];
    [sender setSelected:YES];
    if (lastSelectedButton) {
        [lastSelectedButton setSelected:NO];
    }
    lastSelectedButton = sender;
    [self layoutScrollBar];
    [self scrollViewAtIndex:[sender tag]];
}
- (IBAction)closeAction:(id)sender {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeView) name:@"InvestViewClose" object:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"InvestViewClose" object:nil];
}
@end
