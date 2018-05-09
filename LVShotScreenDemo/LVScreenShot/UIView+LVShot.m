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
