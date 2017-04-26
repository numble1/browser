//
//  mainViewController.h
//  browser
//
//  Created by pathfinder on 2017/4/21.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseCtrl.h"

@protocol mainViewDelegate<NSObject>

-(void)pushToViewController:(UIViewController *)viewC;

@end

@interface mainViewController : baseCtrl
@property(nonatomic,assign)id <mainViewDelegate> delegate;

@end
