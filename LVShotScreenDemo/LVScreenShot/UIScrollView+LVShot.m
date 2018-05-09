//
//  UIScrollView+LVShot.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "UIScrollView+LVShot.h"
#import "UIView+LVShot.h"

@implementation UIScrollView (LVShot)


-(void)DDGContentScreenShot:(void(^)(UIImage*screenShotImage))completion{

    self.isShoting = YES;


    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);

    [self.superview addSubview:snapShotView];


    CGRect bakFrame = self.frame;
    CGPoint bakOffset = self.contentOffset;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex = [self.superview.subviews indexOfObject:self ];



    if(self.frame.size.height<self.contentSize.height){

        self.contentOffset = CGPointMake(0, self.contentSize.height- self.frame.size.height);
    }


    __weak typeof(self) weakSelf = self;

    [self DDGRenderImageView:^(UIImage *screenShotImage) {


        __strong typeof(weakSelf) StrongSelf = weakSelf;

        [StrongSelf removeFromSuperview];
        StrongSelf.frame = bakFrame;
        StrongSelf.contentOffset = bakOffset;
        [bakSuperView insertSubview:StrongSelf atIndex:bakIndex];
        [snapShotView removeFromSuperview];

        StrongSelf.isShoting = NO;
        completion(screenShotImage);


    }];




}

-(void)DDGRenderImageView:(void(^)(UIImage*screenShotImage))completion{



    UIView *ddgTempRenderview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];

    [self removeFromSuperview];

    [ddgTempRenderview addSubview:self ];

    self.contentOffset = CGPointZero;
    self.frame = ddgTempRenderview.frame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        CGRect bounds = self.bounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, NO, UIScreen.mainScreen.scale);
        if(self.DDGContainsWKWebView){
            [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
        }else{
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        }

        UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        completion(screenShotImage);

    });

}

-(void)DDGContentScrollScreenShot:(void(^)(UIImage*screenShotImage))completion{

    self.isShoting = YES;

    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);

    [self.superview addSubview:snapShotView];

    CGPoint bakOffset = self.contentOffset;

    int page = floor(self.contentSize.height/self.bounds.size.height);

    UIGraphicsBeginImageContextWithOptions(self.contentSize, NO, UIScreen.mainScreen.scale);


    __weak typeof(self) weakSelf = self;

     [self DDGContentScrollPageDrawWithIndex:0 MaxIndex:page callBack:^{
         __strong typeof(weakSelf) StrongSelf = weakSelf;

         UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         [StrongSelf setContentOffset:bakOffset animated:NO];
         [snapShotView removeFromSuperview];
         StrongSelf.isShoting = NO;
         completion(screenShotImage);


    }];



}

-(void)DDGContentScrollPageDrawWithIndex:(int)index MaxIndex:(int)maxIndex callBack:(void(^)())callBack{

    [self setContentOffset:CGPointMake(0, index*self.frame.size.height) animated:NO];
    CGRect splitFrame = CGRectMake(0, index*self.frame.size.height, self.bounds.size.width, self.bounds.size.height);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        if(index <maxIndex){

            [self DDGContentScrollPageDrawWithIndex:index+1 MaxIndex:maxIndex callBack:callBack];
        }else{

            callBack();
        }
    });

}



@end


@implementation UIWebView (LVShot)


-(void)DDGContentScreenShot:(void(^)(UIImage*screenShotImage))completion{

    [self.scrollView DDGContentScreenShot:completion];
}

-(void)DDGContentScrollScreenShot:(void(^)(UIImage*screenShotImage))completion{
    [self.scrollView DDGContentScrollScreenShot:completion];
}


@end

