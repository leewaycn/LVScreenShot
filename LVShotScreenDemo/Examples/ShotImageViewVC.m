//
//  ShotImageViewVC.m
//  LVShotScreenDemo
//
//  Created by 孔友夫 on 2018/5/9.
//  Copyright © 2018年 LV. All rights reserved.
//

#import "ShotImageViewVC.h"
#import "UIImage+LVManager.h"

@interface ShotImageViewVC ()
    {

        CGFloat height;
        CGFloat width;
        UIImageView *testImageview;

        UIView *bgView;
        CGPoint startPoint;
    }
@end

@implementation ShotImageViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    height = UIScreen.mainScreen.bounds.size.height;

    width = UIScreen.mainScreen.bounds.size.width;

    self.view.backgroundColor = [UIColor whiteColor];


    testImageview = [UIImageView new];
    testImageview.image = [UIImage imageNamed:@"0"];
    testImageview.frame = CGRectMake(0, 0, width, height-00);

    [self.view addSubview:testImageview];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(startpanTouch:)];

    [testImageview addGestureRecognizer:pan];


    testImageview.userInteractionEnabled = YES;

    

}

    -(void)setBgView{
        if(!bgView  ){
            bgView = [UIView new];
        }
        [self.view addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.7;

    }

    -(void)startpanTouch:(UIPanGestureRecognizer*)pan{


        CGPoint  shotPan =  [pan locationInView:testImageview];
        [self setBgView];

        if(pan.state==  UIGestureRecognizerStateBegan){
            startPoint = shotPan;
        }
        else if (pan.state==UIGestureRecognizerStateChanged){
            CGFloat x = startPoint.x;
            CGFloat y = startPoint.y;
            CGFloat w = shotPan.x - startPoint.x;
            CGFloat h = shotPan.y - startPoint.y;

            CGRect rect = CGRectMake(x, y, w, h);
            bgView.frame = rect;


        }
        else if (pan.state == UIGestureRecognizerStateEnded){

            UIImage *image = [[LVManager share] shotImage:testImageview bgView:bgView];

            [bgView removeFromSuperview];
            bgView = nil;

            UIImageView *imview = [UIImageView new];
            [self.view addSubview:imview];
            imview.image = image;
            imview.frame = CGRectMake(100, 200, 200, 200);
        }


    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
