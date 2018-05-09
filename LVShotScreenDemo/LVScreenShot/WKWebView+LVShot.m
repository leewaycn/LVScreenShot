//
//  WKWebView+LVShot.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/8.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "WKWebView+LVShot.h"
#import "UIView+LVShot.h"


#import <WebKit/WebKit.h>

@implementation WKWebView (LVShot)

-(void)DDGContentScreenShot:(void(^)(UIImage*screenShotImage))completion{

    self.isShoting = YES;

    CGPoint offset = self.scrollView.contentOffset;

    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);

    [self.superview addSubview:snapShotView];

    if(self.frame.size.height <self.scrollView.contentSize.height){
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height-self.frame.size.height);

    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        self.scrollView.contentOffset = CGPointZero;

        __weak typeof(self) weakSelf = self;
        [self DDGContentScreenShotWithoutOffset:^(UIImage *screenShotImage) {


            __strong typeof(weakSelf) StrongSElf = weakSelf;

            StrongSElf.scrollView .contentOffset = offset;
            [snapShotView removeFromSuperview];
            StrongSElf.isShoting = NO;
            completion(screenShotImage);

        }];


    });



}

-(void)DDGContentScreenShotWithoutOffset:(void(^)(UIImage*screenShotImage))completion{

    UIView *containerView = [[UIView alloc]initWithFrame:self.bounds ];
    CGRect bakFrame = self.frame;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex =[ self.superview.subviews indexOfObject:self];


    [self removeFromSuperview];
    [containerView addSubview:self];
    CGSize totalSize = self.scrollView.contentSize;

    NSInteger page = floor(totalSize.height/containerView.bounds.size.height);
    self.frame = CGRectMake(0, 0, containerView.frame.size.width, self.scrollView.contentSize.height);

        UIGraphicsBeginImageContextWithOptions(totalSize, NO, UIScreen.mainScreen.scale);

    __weak typeof(self) weakSelf = self;

    [self DDGContentPageDrawWithUIView:containerView Index:0 MaxIndex:(int)page DrawCallBack:^{


        __strong typeof(weakSelf) StrongSelf = weakSelf;

        UIImage *screnShotImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        [StrongSelf removeFromSuperview];
        [bakSuperView insertSubview:StrongSelf atIndex:bakIndex];
        StrongSelf.frame = bakFrame;
        [containerView removeFromSuperview];

        completion(screnShotImage);


    }];


}

-(void)DDGContentPageDrawWithUIView:(UIView*)targetView Index:(int) index MaxIndex:(int)maxIndex DrawCallBack:(void (^)(void))callBack{


    CGRect splitFrame = CGRectMake(0, index *targetView.frame.size.height, targetView.bounds.size.width, targetView.frame.size.height);

    CGRect myFrame = self.frame;
    myFrame.origin.y = - index*targetView.frame.size.height;
    self.frame = myFrame;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];

        if(index <maxIndex){
            [self DDGContentPageDrawWithUIView:targetView Index:index+1 MaxIndex:maxIndex DrawCallBack:callBack];
        }else{
            callBack();
        }
    });

}


-(void)shotScreenContentScrollCapture:(void(^)(UIImage*screenShotImage))completion{

    self.isShoting = YES;


    UIView *snapShotVIew = [self snapshotViewAfterScreenUpdates:YES];

    snapShotVIew.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotVIew.frame.size.width, snapShotVIew.frame.size.height);

    [self.superview snapshotViewAfterScreenUpdates:snapShotVIew];

    CGPoint bakOffset = self.scrollView.contentOffset;
    int page = floor(self.scrollView.contentSize.height/self.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, NO, UIScreen.mainScreen.scale);


    __weak typeof(self) weakself = self;
    [self shotScreenContentScrollPageDrawWithIndex:0 MaxIndex:page DrawCallBack:^{

        __strong typeof(weakself) StrongSelf = weakself;

        UIImage *captureImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();


        [StrongSelf.scrollView setContentOffset:bakOffset    animated:NO];

        [snapShotVIew removeFromSuperview];

        StrongSelf.isShoting = NO;
        completion(captureImage);


    }];




}

-(void)shotScreenContentScrollPageDrawWithIndex:(int)index MaxIndex:(int)maxIndex DrawCallBack:(void (^)(void))callBack{

    [self.scrollView setContentOffset:CGPointMake(0, index*self.scrollView.frame.size.height) animated:NO];

    CGRect splitFrame = CGRectMake(0, index*self.scrollView.frame.size.height, self.bounds.size.width, self.bounds.size.height);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{


        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];

        if(index <maxIndex){
            [self shotScreenContentScrollPageDrawWithIndex:index+1 MaxIndex:maxIndex DrawCallBack:callBack];
        }else{
            callBack();
        }

    });
}
    


@end
