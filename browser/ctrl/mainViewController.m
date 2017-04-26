//
//  mainViewController.m
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "mainViewController.h"
#import "NTButton.h"
#import "UIImage+scale.h"
#import "ViewController.h"
#import "newsTableViewCell.h"
#import "NewsBean.h"
#import <SDWebImage/UIImageView+WebCache.h>



@interface mainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation mainViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // _currentIndexBtn.titleLabel.text = @"1";
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    for (int i = 0; i<10; i++) {
        [self creatButtonWithNormalName:@"主页" andTitle:@"测试" andIndex:i];
    }
    [self fetchDataWithskip:0 andWithlimit:10];
    [self.tableView registerNib:[UINib nibWithNibName:@"newsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"news"];
    
}
- (void)creatButtonWithNormalName:(NSString *)normal andTitle:(NSString *)title andIndex:(int)index{
    
    NTButton * customButton = [NTButton buttonWithType:UIButtonTypeCustom];
    customButton.tag = index;
    CGFloat buttonW = [UIScreen mainScreen].bounds.size.width / 5;
    CGFloat buttonH = self.topView.frame.size.height/2;
    customButton.frame = CGRectMake(buttonW * (index%5),buttonH*(index/5), buttonW, buttonH);
    [customButton setImage:[[UIImage imageNamed:normal] scaleToSize:CGSizeMake(22, 22)] forState:UIControlStateNormal];
    [customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    customButton.titleLabel.font = [UIFont systemFontOfSize:20];
    //这里应该设置选中状态的图片。wsq
    [customButton setTitle:title forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    customButton.imageView.contentMode = UIViewContentModeCenter;
    customButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:customButton];
}
-(void)click:(NTButton*)sender{
#pragma mark 动态修改
//    NSInteger tag = sender.tag;
    ViewController* webCtrl = [[ViewController alloc]init];
     webCtrl.urlStr = @"https://www.baidu.com/";
  //  NSInteger index = self.currentIndexBtn.titleLabel.text.integerValue;
 //   self.currentIndexBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",index+1];
    [self.delegate pushToViewController:webCtrl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.beanArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    newsTableViewCell*cell = [self.tableView dequeueReusableCellWithIdentifier:@"news"];
    if (!cell) {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"newsTableViewCell" owner:self options:nil];
        cell = arr[0];
    }
    NewsBean *bean = self.beanArr[indexPath.row];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:bean.icon]];
    cell.time.text = bean.time;
    cell.type.text = bean.src;
    cell.title.text = bean.name;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}


-(void)reloadTableView{
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsBean*bean  = self.beanArr[indexPath.row];
    ViewController* webCtrl = [[ViewController alloc]init];
    webCtrl.urlStr = bean.detail_link;
 //   NSInteger index = self.currentIndexBtn.titleLabel.text.integerValue;
//    self.currentIndexBtn.titleLabel.text = [NSString stringWithFormat:@"%ld",index+1];
    [self.delegate pushToViewController:webCtrl];
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
