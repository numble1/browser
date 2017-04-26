//
//  GDpageViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/25.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "GDpageViewController.h"
#import "mainViewController.h"
#import "ViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface GDpageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,pushDelegate,mainViewDelegate>
@property(nonatomic,strong) UIPageViewController *pageVC;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *viewControllers;
@end

@implementation GDpageViewController
-(NSMutableArray *)viewControllers{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
        mainViewController *main = [mainViewController new];
        main.delegate=self;
        [_viewControllers addObject:main];
    }return _viewControllers;
}
- (UIPageViewController *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        _pageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        for (UIView *subview in _pageVC.view.subviews) {
            
            [(UIScrollView *)subview setDelegate:self];
            //设置是否支持手势滑动
            //            [(UIScrollView *)subview setScrollEnabled:NO];
            
        }
          [_pageVC setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    return _pageVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.view bringSubviewToFront:self.bottomView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Tool
// 根据数组元素，得到下标值
- (NSUInteger)indexOfViewController:(UIViewController *)viewControlller{
    return [self.viewControllers indexOfObject:viewControlller];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    return self.viewControllers[index];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return self.viewControllers[index];
}
#pragma pushDelegate
-(void)pushToViewController:(UIViewController *)viewC{
    [self.viewControllers addObject:viewC];
    ViewController *webCtrl = (ViewController *)viewC;
    webCtrl.delegate = self;
    [_pageVC setViewControllers:@[viewC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
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
