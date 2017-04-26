//
//  baseCtrl.m
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "baseCtrl.h"
#import <AFNetwork.h>
#import "JSONParseManager.h"
#import "NewsBean.h"
#import <UIView+Toast.h>
#define NEWS_API @"http://service.newsad.adesk.com/v1/news"
@interface baseCtrl ()

@end

@implementation baseCtrl
-(NSMutableArray *)beanArr{
    if (!_beanArr) {
        _beanArr = [NSMutableArray array];
    }return _beanArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fetchDataWithskip:(NSInteger)skip andWithlimit:(NSInteger)limit {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%ld",skip] forKey:@"skip"];
    [params setValue: [NSString stringWithFormat:@"%ld",limit] forKey:@"limit"];
    [[AFNetwork shareManager] requestURL:NEWS_API
                                  params:params
                                 success:^(NSURLSessionDataTask *task, NSDictionary *dict) {
                                     NSArray *news = [JSONParseManager parse2Array:[NewsBean class] jsonDict:dict arrayKey:@"news"];
                                     [self.beanArr addObjectsFromArray:news];
                                     NSInteger code = [JSONParseManager parse2Code:dict];
                                     NSString *msg = [JSONParseManager parse2Msg:dict];
                                     if (code != 0) {
                                         [self.view makeToast:msg];
                                         return;
                                     }
                                     
                                     if (!news) {
                                         [self.view makeToast:@"未知错误"];
                                         return;
                                     }
                                     [self reloadTableView];
//                                     AdParseBean *ad = [AdManager getAd];
//                                     if (ad) {
//                                         news = [AdManager mergeAd:news];
//                                     }
//                                     
//                                     [items addObjectsFromArray:news];
//                                     if (news.count == 0||news == nil) {
//                                         MJRefreshAutoFooterIdleText = @"MJRefreshAutoFooterNoMoreDataText";
//                                         self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                                             [self fetchData];
//                                         }];
//                                         [self.tableView.mj_footer endRefreshingWithNoMoreData];
//                                     }
//                                     
                              //       [self.tableView reloadData];
                                 }
                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"错误%@",error);
                                 }
                                  finish:^{
                                      
//                                      [self.tableView reloadData];
//                                      [self.tableView.mj_header endRefreshing];
//                                      [self.tableView.mj_footer endRefreshing];
                                  }];
}
-(void)reloadTableView{
    
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
