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
#import "exploreView.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface GDpageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,pushDelegate,mainViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) UIPageViewController *pageVC;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UISearchBar *topView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic,strong)NSMutableArray *viewControllers;
@property(nonatomic,strong)UIViewController*currentCtrl;
@property(nonatomic,strong)exploreView *exploreview;
@end

@implementation GDpageViewController
-(exploreView *)exploreview{
    if (!_exploreview) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"exploreView" owner:self options:nil];
        _exploreview = arr[0];
    }return _exploreview;
}
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
        _pageVC.view.frame = self.mainView.frame;
        [self.view addSubview:_pageVC.view];
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideExploreView) name:@"hideExplore" object:nil];
    self.topView.delegate =self;
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.topView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.topView.placeholder = @"请输入网址";
}
#pragma mark searchDelegat
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    ViewController *webCtrl = [[ViewController alloc]init];
    webCtrl.urlStr = [NSString stringWithFormat:@"https://%@",searchBar.text];
    [self pushToViewController:webCtrl];
    [self.topView endEditing:YES];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
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
    self.currentCtrl = webCtrl;
    webCtrl.delegate = self;
    [_pageVC setViewControllers:@[viewC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    NSArray* arr = self.pageVC.viewControllers;
    UIViewController *main = arr[0];
    if ([main isKindOfClass:[mainViewController class]]) {
        self.topView.placeholder = @"请输入网址";
    }
    else{
        ViewController *webCtrl = (ViewController*) main;
        self.topView.text = webCtrl.urlStr;
    }
}
- (IBAction)backward:(id)sender {
    NSUInteger index = [self indexOfViewController:self.currentCtrl];
    if (index==self.viewControllers.count-1) {
        return;
    }
    UIViewController *viewCtrl = self.viewControllers[index+1];
    self.currentCtrl=viewCtrl;
     [_pageVC setViewControllers:@[viewCtrl] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}
- (IBAction)forward:(id)sender {
    NSUInteger index = [self indexOfViewController:self.currentCtrl];
    if (index==0||!index) {
        return;
    }
    UIViewController *viewCtrl = self.viewControllers[index-1];
    self.currentCtrl = viewCtrl;
    [_pageVC setViewControllers:@[viewCtrl] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
- (IBAction)addNewweb:(id)sender {
    
}
- (IBAction)goHome:(id)sender {
    UIViewController *viewCtrl = self.viewControllers[0];
    self.currentCtrl = viewCtrl;
    [_pageVC setViewControllers:@[viewCtrl] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (IBAction)explore:(id)sender {
    [self showExploreView];
}

-(void)showExploreView{
    self.exploreview.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH ,160);
    [self.view addSubview:self.exploreview];
    [UIView animateWithDuration:0.3 animations:^{
        self.exploreview.frame = CGRectMake(0, SCREEN_HEIGHT-160,SCREEN_WIDTH ,160);
    }];
}
-(void)hideExploreView{
    if ([self.topView isFirstResponder]) {
    [self.topView resignFirstResponder];
    }
    [self.exploreview removeFromSuperview];
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
