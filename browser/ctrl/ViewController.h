//
//  ViewController.h
//  browser
//
//  Created by pathfinder on 2017/4/24.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol pushDelegate <NSObject>
-(void)pushToViewController:(UIViewController *)viewC;
@end

@interface ViewController : UIViewController
@property(nonatomic,strong)NSString *urlStr;
@property(nonatomic,assign)id <pushDelegate> delegate;
@end
