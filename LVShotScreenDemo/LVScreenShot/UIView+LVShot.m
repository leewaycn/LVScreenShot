//
//  UIView+LVShot.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "UIView+LVShot.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>

static const NSString * DDGViewScreenShotKey_IsShoting = @"DDGViewScreenShotKey_IsShoting";


@implementation UIView (LVShot)


-(void)setIsShoting:(BOOL)isShoting{
    NSNumber *num = [NSNumber numberWithBool:isShoting];
    objc_setAssociatedObject(self, &DDGViewScreenShotKey_IsShoting, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isShoting{

    NSNumber *number = objc_getAssociatedObject(self,&DDGViewScreenShotKey_IsShoting);

    if(number==nil){
        return NO;
    }

    if(number ){
        return number.boolValue;
    }
    return NO;
}

-(BOOL)DDGContainsWKWebView{

    if([self isKindOfClass:[WKWebView class]]){

        return YES;
    }

    for (UIView *sbView in self.subviews) {


        if([sbView DDGContainsWKWebView]){
            return YES;
        }
    }
    return NO;

}
-(void)DDGScreenShotWithCompletionHandle:(void(^)(UIImage*screenShotImage))completion{

    self.isShoting = YES;

    CGRect bounds = self.bounds;

    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, -self.frame.origin.x, -self.frame.origin.y);


    if ([self isKindOfClass:[UIWindow class]]) {
        CGSize imageSize = CGSizeZero;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation))
            imageSize = [UIScreen mainScreen].bounds.size;
        else
            imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);

        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (UIWindow *window in [[UIApplication sharedApplication] windows])
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, window.center.x, window.center.y);
            CGContextConcatCTM(context, window.transform);
            CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
            if (orientation == UIInterfaceOrientationLandscapeLeft)
            {
                CGContextRotateCTM(context, M_PI_2);
                CGContextTranslateCTM(context, 0, -imageSize.width);
            }
            else if (orientation == UIInterfaceOrientationLandscapeRight)
            {
                CGContextRotateCTM(context, -M_PI_2);
                CGContextTranslateCTM(context, -imageSize.height, 0);
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
                CGContextRotateCTM(context, M_PI);
                CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
            }
            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
            {
                [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
            }
            else
            {
                [window.layer renderInContext:context];
            }
            CGContextRestoreGState(context);
        }


    }else

    if([ self DDGContainsWKWebView ]){
        [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:context];
    }

    UIImage *shotImage  = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();

    self.isShoting = NO;

    completion(shotImage);


}



    

@end
