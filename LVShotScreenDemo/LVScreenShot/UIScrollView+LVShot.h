//
//  UIScrollView+LVShot.h
//  LVShotScreenDemo
//
//  Created by leewaycn on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LVShot)


-(void)DDGContentScreenShot:(void(^)(UIImage*screenShotImage))completion;

-(void)DDGContentScrollScreenShot:(void(^)(UIImage*screenShotImage))completion;


@end


@interface UIWebView (LVShot)

-(void)DDGContentScreenShot:(void(^)(UIImage*screenShotImage))completion;
-(void)DDGContentScrollScreenShot:(void(^)(UIImage*screenShotImage))completion;

@end
