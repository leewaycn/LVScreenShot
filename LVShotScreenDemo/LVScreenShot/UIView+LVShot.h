//
//  UIView+LVShot.h
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LVShot)



@property (nonatomic,assign)BOOL  isShoting;
-(BOOL)DDGContainsWKWebView;


-(void)DDGScreenShotWithCompletionHandle:(void(^)(UIImage*screenShotImage))completion;


@end
