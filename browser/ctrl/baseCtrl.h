//
//  baseCtrl.h
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseCtrl : UIViewController
@property (nonatomic,strong)NSMutableArray *beanArr;
-(void)reloadTableView;
- (void)fetchDataWithskip:(NSInteger)skip andWithlimit:(NSInteger)limit;
@end
