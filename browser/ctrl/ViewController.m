//
//  ViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/24.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,unsafe_unretained)BOOL couldLoadWeb;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    //用了判断是否是点击进入网页
     self.couldLoadWeb  = NO;
}
//加载完成之前不允许响应点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSData *data = [NSData dataWithContentsOfURL:request.URL];
//    NSString * st = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  //    NSLog(@"%@",st);
//    NSLog(@"type %ld",navigationType);
    //判断是否是单击
    if (self.couldLoadWeb)
    {
        ViewController*webCtrl = [[ViewController alloc]init];
        webCtrl.urlStr = request.URL.absoluteString;
        [self.delegate pushToViewController:webCtrl];
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!webView.isLoading) {
        NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
        BOOL complete = [readyState isEqualToString:@"complete"];
        if (complete) {
            self.couldLoadWeb = YES;
        }
    }
   
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
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
