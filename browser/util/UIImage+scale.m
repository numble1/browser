//
//  UIImage+scale.m
//  batteryDoctor
//
//  Created by pathfinder on 2017/4/6.
//  Copyright © 2017年 pathfinder. All rights reserved.
//

#import "UIImage+scale.h"

@implementation UIImage (scale)
-(UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
     UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
